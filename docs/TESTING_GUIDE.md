# NextJob - Guia de Teste das Operações CRUD

## 🧪 Testando as APIs

### Pré-requisitos
- Aplicação rodando em http://localhost:8080
- Banco de dados PostgreSQL configurado
- Tool para testes: cURL, Postman, ou interface web

---

## 📌 CRUD de Candidatos

### 1. CREATE - Criar Novo Candidato

**Via cURL:**
```bash
curl -X POST http://localhost:8080/api/candidates \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "João Silva",
    "email": "joao.silva@email.com",
    "skills": ["Java", "Spring Boot", "PostgreSQL", "Docker"]
  }'
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/candidates
2. Clique em "➕ Novo Candidato"
3. Preencha o formulário
4. Clique em "Salvar Candidato"

**Verificar no Banco:**
```sql
SELECT * FROM candidate WHERE email = 'joao.silva@email.com';
SELECT * FROM candidate_skills WHERE candidate_id = 1;
```

---

### 2. READ - Listar Candidatos

**Via cURL:**
```bash
# Listar todos
curl http://localhost:8080/api/candidates

# Buscar por ID
curl http://localhost:8080/api/candidates/1
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/candidates
2. Visualize a tabela com todos os candidatos

**Verificar no Banco:**
```sql
SELECT c.id, c.full_name, c.email, 
       STRING_AGG(cs.skill, ', ') as skills
FROM candidate c
LEFT JOIN candidate_skills cs ON c.id = cs.candidate_id
GROUP BY c.id, c.full_name, c.email;
```

---

### 3. UPDATE - Atualizar Candidato

**Via cURL:**
```bash
curl -X PUT http://localhost:8080/api/candidates/1 \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "João Silva Atualizado",
    "email": "joao.silva@email.com",
    "skills": ["Java", "Spring Boot", "Azure", "Kubernetes"]
  }'
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/candidates
2. Clique no botão "✏️" na linha do candidato
3. Modifique os dados desejados
4. Clique em "Salvar Candidato"

**Verificar no Banco:**
```sql
-- Verificar atualização do nome
SELECT * FROM candidate WHERE id = 1;

-- Verificar atualização das habilidades
SELECT skill FROM candidate_skills WHERE candidate_id = 1;
```

---

### 4. DELETE - Excluir Candidato

**Via cURL:**
```bash
curl -X DELETE http://localhost:8080/api/candidates/1
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/candidates
2. Clique no botão "🗑️" na linha do candidato
3. Confirme a exclusão

**Verificar no Banco:**
```sql
-- Verificar se foi excluído
SELECT * FROM candidate WHERE id = 1;

-- Verificar se as habilidades foram excluídas (CASCADE)
SELECT * FROM candidate_skills WHERE candidate_id = 1;
```

---

## 💼 CRUD de Vagas

### 1. CREATE - Criar Nova Vaga

**Via cURL:**
```bash
curl -X POST http://localhost:8080/api/vacancies \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Desenvolvedor Java Sênior",
    "description": "Buscamos desenvolvedor com experiência em Spring Boot",
    "requiredSkills": ["Java", "Spring Boot", "PostgreSQL", "Docker"]
  }'
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/vacancies
2. Clique em "➕ Nova Vaga"
3. Preencha o formulário
4. Clique em "Salvar Vaga"

**Verificar no Banco:**
```sql
SELECT * FROM vacancy WHERE title = 'Desenvolvedor Java Sênior';
SELECT * FROM vacancy_skills WHERE vacancy_id = 1;
```

---

### 2. READ - Listar Vagas

**Via cURL:**
```bash
# Listar todas
curl http://localhost:8080/api/vacancies

# Buscar por ID
curl http://localhost:8080/api/vacancies/1
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/vacancies
2. Visualize os cards com todas as vagas

**Verificar no Banco:**
```sql
SELECT v.id, v.title, v.description,
       STRING_AGG(vs.skill, ', ') as required_skills
FROM vacancy v
LEFT JOIN vacancy_skills vs ON v.id = vs.vacancy_id
GROUP BY v.id, v.title, v.description;
```

---

### 3. UPDATE - Atualizar Vaga

**Via cURL:**
```bash
curl -X PUT http://localhost:8080/api/vacancies/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Desenvolvedor Java Sênior - Atualizado",
    "description": "Nova descrição da vaga",
    "requiredSkills": ["Java", "Spring Boot", "Azure", "Kubernetes", "CI/CD"]
  }'
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/vacancies
2. Clique no botão "✏️" no card da vaga
3. Modifique os dados desejados
4. Clique em "Salvar Vaga"

**Verificar no Banco:**
```sql
-- Verificar atualização do título e descrição
SELECT * FROM vacancy WHERE id = 1;

-- Verificar atualização das habilidades requeridas
SELECT skill FROM vacancy_skills WHERE vacancy_id = 1;
```

---

### 4. DELETE - Excluir Vaga

**Via cURL:**
```bash
curl -X DELETE http://localhost:8080/api/vacancies/1
```

**Via Interface Web:**
1. Acesse: http://localhost:8080/vacancies
2. Clique no botão "🗑️" no card da vaga
3. Confirme a exclusão

**Verificar no Banco:**
```sql
-- Verificar se foi excluída
SELECT * FROM vacancy WHERE id = 1;

-- Verificar se as habilidades foram excluídas (CASCADE)
SELECT * FROM vacancy_skills WHERE vacancy_id = 1;
```

---

## 🎯 Testar Match/Compatibilidade

### Calcular Compatibilidade

**Via cURL:**
```bash
curl -X POST http://localhost:8080/api/match/compatibility \
  -H "Content-Type: application/json" \
  -d '{
    "candidateId": 1,
    "vacancyId": 1
  }'
```

**Via Interface Web:**
1. Acesse: http://localhost:8080
2. Na seção "Calcular Compatibilidade"
3. Selecione um candidato e uma vaga
4. Clique em "Calcular Compatibilidade"
5. Visualize o resultado percentual

**Interpretar Resultado:**
- **80-100%**: Excelente match
- **60-79%**: Bom match
- **40-59%**: Match moderado
- **0-39%**: Match baixo

---

## 📊 Script Completo de Teste

```bash
#!/bin/bash

BASE_URL="http://localhost:8080/api"

echo "=== TESTE COMPLETO DE CRUD ==="

# 1. CREATE Candidato
echo "1. Criando candidato..."
curl -X POST $BASE_URL/candidates \
  -H "Content-Type: application/json" \
  -d '{"fullName":"João Silva","email":"joao.silva@test.com","skills":["Java","Spring Boot"]}'

# 2. READ Candidatos
echo -e "\n\n2. Listando candidatos..."
curl $BASE_URL/candidates

# 3. UPDATE Candidato
echo -e "\n\n3. Atualizando candidato..."
curl -X PUT $BASE_URL/candidates/1 \
  -H "Content-Type: application/json" \
  -d '{"fullName":"João Silva Atualizado","email":"joao.silva@test.com","skills":["Java","Azure"]}'

# 4. CREATE Vaga
echo -e "\n\n4. Criando vaga..."
curl -X POST $BASE_URL/vacancies \
  -H "Content-Type: application/json" \
  -d '{"title":"Dev Java","description":"Vaga para desenvolvedor","requiredSkills":["Java","Spring Boot"]}'

# 5. READ Vagas
echo -e "\n\n5. Listando vagas..."
curl $BASE_URL/vacancies

# 6. Calcular Match
echo -e "\n\n6. Calculando compatibilidade..."
curl -X POST $BASE_URL/match/compatibility \
  -H "Content-Type: application/json" \
  -d '{"candidateId":1,"vacancyId":1}'

# 7. DELETE Candidato
echo -e "\n\n7. Excluindo candidato..."
curl -X DELETE $BASE_URL/candidates/1

# 8. DELETE Vaga
echo -e "\n\n8. Excluindo vaga..."
curl -X DELETE $BASE_URL/vacancies/1

echo -e "\n\n=== TESTES CONCLUÍDOS ==="
```

---

## ✅ Checklist de Validação

Para o vídeo de apresentação, certifique-se de demonstrar:

- [ ] **CREATE**: Inserir novo candidato e vaga
- [ ] **READ**: Listar todos os registros
- [ ] **READ BY ID**: Buscar por ID específico
- [ ] **UPDATE**: Atualizar dados existentes
- [ ] **DELETE**: Excluir registros
- [ ] **Verificação no Banco**: Mostrar dados diretamente no PostgreSQL
- [ ] **Match**: Calcular compatibilidade entre candidato e vaga
- [ ] **Interface Web**: Demonstrar todas as páginas funcionando
- [ ] **Testes Contínuos**: Executar sem cortes no vídeo

---

## 🔍 Queries SQL Úteis

```sql
-- Ver todos os candidatos com suas habilidades
SELECT c.id, c.full_name, c.email, 
       STRING_AGG(cs.skill, ', ' ORDER BY cs.skill) as skills
FROM candidate c
LEFT JOIN candidate_skills cs ON c.id = cs.candidate_id
GROUP BY c.id, c.full_name, c.email
ORDER BY c.id;

-- Ver todas as vagas com habilidades requeridas
SELECT v.id, v.title, 
       STRING_AGG(vs.skill, ', ' ORDER BY vs.skill) as required_skills
FROM vacancy v
LEFT JOIN vacancy_skills vs ON v.id = vs.vacancy_id
GROUP BY v.id, v.title
ORDER BY v.id;

-- Contar registros
SELECT 
    (SELECT COUNT(*) FROM candidate) as total_candidates,
    (SELECT COUNT(*) FROM vacancy) as total_vacancies,
    (SELECT COUNT(*) FROM candidate_skills) as total_candidate_skills,
    (SELECT COUNT(*) FROM vacancy_skills) as total_vacancy_skills;
```
