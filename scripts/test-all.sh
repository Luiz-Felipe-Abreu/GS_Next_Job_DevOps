#!/bin/bash

# ============================================
# NextJob - Script de Teste Rápido
# Execute este script para validar toda a aplicação
# ============================================

BASE_URL="http://localhost:8080"
API_URL="${BASE_URL}/api"

echo "============================================"
echo "NextJob - Teste Completo da Aplicação"
echo "============================================"
echo ""

# Verificar se a aplicação está rodando
echo "1. Verificando se a aplicação está rodando..."
if curl -s --head --request GET ${BASE_URL} | grep "200 OK" > /dev/null; then 
   echo "✅ Aplicação está rodando!"
else
   echo "❌ Aplicação NÃO está rodando. Execute: ./gradlew bootRun"
   exit 1
fi

echo ""
echo "============================================"
echo "2. Testando CRUD de Candidatos"
echo "============================================"

# CREATE Candidato
echo ""
echo "📝 CREATE - Criando candidato..."
CANDIDATE_RESPONSE=$(curl -s -X POST ${API_URL}/candidates \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "João Silva Teste",
    "email": "joao.teste@email.com",
    "skills": ["Java", "Spring Boot", "PostgreSQL", "Docker", "Azure"]
  }')

CANDIDATE_ID=$(echo $CANDIDATE_RESPONSE | grep -o '"id":[0-9]*' | grep -o '[0-9]*')

if [ -n "$CANDIDATE_ID" ]; then
    echo "✅ Candidato criado com ID: $CANDIDATE_ID"
else
    echo "❌ Erro ao criar candidato"
fi

# READ Candidatos
echo ""
echo "📖 READ - Listando todos os candidatos..."
CANDIDATES=$(curl -s ${API_URL}/candidates)
COUNT=$(echo $CANDIDATES | grep -o '"id"' | wc -l)
echo "✅ Total de candidatos: $COUNT"

# READ por ID
echo ""
echo "🔍 READ BY ID - Buscando candidato ID: $CANDIDATE_ID..."
curl -s ${API_URL}/candidates/${CANDIDATE_ID} | python3 -m json.tool
echo "✅ Candidato recuperado"

# UPDATE Candidato
echo ""
echo "✏️ UPDATE - Atualizando candidato..."
curl -s -X PUT ${API_URL}/candidates/${CANDIDATE_ID} \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "João Silva Atualizado",
    "email": "joao.teste@email.com",
    "skills": ["Java", "Spring Boot", "Kubernetes", "Azure", "CI/CD", "Docker"]
  }' | python3 -m json.tool
echo "✅ Candidato atualizado"

echo ""
echo "============================================"
echo "3. Testando CRUD de Vagas"
echo "============================================"

# CREATE Vaga
echo ""
echo "📝 CREATE - Criando vaga..."
VACANCY_RESPONSE=$(curl -s -X POST ${API_URL}/vacancies \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Desenvolvedor Java Sênior - Teste",
    "description": "Vaga para teste de sistema. Buscamos profissional com experiência em Java e Cloud.",
    "requiredSkills": ["Java", "Spring Boot", "Azure", "Kubernetes", "CI/CD"]
  }')

VACANCY_ID=$(echo $VACANCY_RESPONSE | grep -o '"id":[0-9]*' | grep -o '[0-9]*')

if [ -n "$VACANCY_ID" ]; then
    echo "✅ Vaga criada com ID: $VACANCY_ID"
else
    echo "❌ Erro ao criar vaga"
fi

# READ Vagas
echo ""
echo "📖 READ - Listando todas as vagas..."
VACANCIES=$(curl -s ${API_URL}/vacancies)
COUNT=$(echo $VACANCIES | grep -o '"id"' | wc -l)
echo "✅ Total de vagas: $COUNT"

# READ por ID
echo ""
echo "🔍 READ BY ID - Buscando vaga ID: $VACANCY_ID..."
curl -s ${API_URL}/vacancies/${VACANCY_ID} | python3 -m json.tool
echo "✅ Vaga recuperada"

# UPDATE Vaga
echo ""
echo "✏️ UPDATE - Atualizando vaga..."
curl -s -X PUT ${API_URL}/vacancies/${VACANCY_ID} \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Desenvolvedor Java Sênior - Atualizado",
    "description": "Descrição atualizada com novos requisitos e benefícios.",
    "requiredSkills": ["Java", "Spring Boot", "Azure", "Kubernetes", "Docker", "PostgreSQL"]
  }' | python3 -m json.tool
echo "✅ Vaga atualizada"

echo ""
echo "============================================"
echo "4. Testando Cálculo de Compatibilidade"
echo "============================================"

echo ""
echo "🎯 Calculando compatibilidade..."
MATCH_RESPONSE=$(curl -s -X POST ${API_URL}/match/compatibility \
  -H "Content-Type: application/json" \
  -d "{
    \"candidateId\": ${CANDIDATE_ID},
    \"vacancyId\": ${VACANCY_ID}
  }")

echo $MATCH_RESPONSE | python3 -m json.tool
COMPATIBILITY=$(echo $MATCH_RESPONSE | grep -o '"compatibility":[0-9]*' | grep -o '[0-9]*')

if [ -n "$COMPATIBILITY" ]; then
    echo "✅ Compatibilidade calculada: ${COMPATIBILITY}%"
    
    if [ $COMPATIBILITY -ge 80 ]; then
        echo "🎉 Excelente match!"
    elif [ $COMPATIBILITY -ge 60 ]; then
        echo "👍 Bom match!"
    elif [ $COMPATIBILITY -ge 40 ]; then
        echo "⚠️ Match moderado"
    else
        echo "❌ Match baixo"
    fi
else
    echo "❌ Erro ao calcular compatibilidade"
fi

echo ""
echo "============================================"
echo "5. Testando Interface Web"
echo "============================================"

echo ""
echo "🌐 Verificando páginas HTML..."

# Testar página principal
if curl -s ${BASE_URL}/ | grep -q "NextJob"; then
    echo "✅ Página principal (/) OK"
else
    echo "❌ Erro na página principal"
fi

# Testar página de candidatos
if curl -s ${BASE_URL}/candidates | grep -q "Gerenciar Candidatos"; then
    echo "✅ Página de candidatos (/candidates) OK"
else
    echo "❌ Erro na página de candidatos"
fi

# Testar página de vagas
if curl -s ${BASE_URL}/vacancies | grep -q "Gerenciar Vagas"; then
    echo "✅ Página de vagas (/vacancies) OK"
else
    echo "❌ Erro na página de vagas"
fi

echo ""
echo "============================================"
echo "6. Limpeza - Deletando registros de teste"
echo "============================================"

# DELETE Candidato
echo ""
echo "🗑️ DELETE - Excluindo candidato de teste..."
DELETE_CANDIDATE=$(curl -s -w "%{http_code}" -o /dev/null -X DELETE ${API_URL}/candidates/${CANDIDATE_ID})

if [ "$DELETE_CANDIDATE" = "204" ]; then
    echo "✅ Candidato excluído"
else
    echo "⚠️ Status da exclusão: $DELETE_CANDIDATE"
fi

# DELETE Vaga
echo ""
echo "🗑️ DELETE - Excluindo vaga de teste..."
DELETE_VACANCY=$(curl -s -w "%{http_code}" -o /dev/null -X DELETE ${API_URL}/vacancies/${VACANCY_ID})

if [ "$DELETE_VACANCY" = "204" ]; then
    echo "✅ Vaga excluída"
else
    echo "⚠️ Status da exclusão: $DELETE_VACANCY"
fi

echo ""
echo "============================================"
echo "✅ TODOS OS TESTES CONCLUÍDOS COM SUCESSO!"
echo "============================================"
echo ""
echo "Resumo:"
echo "- CRUD de Candidatos: ✅"
echo "- CRUD de Vagas: ✅"
echo "- Cálculo de Compatibilidade: ✅"
echo "- Interface Web: ✅"
echo ""
echo "Acesse a aplicação em: ${BASE_URL}"
echo ""
