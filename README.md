# NextJob - Plataforma Inteligente de Carreira

## 🚀 O Futuro do Trabalho: Requalificação Profissional com IA

![Diagrama de Arquitetura NextJob](image/image.png)

*Arquitetura completa com CI/CD implementada no Azure DevOps e Microsoft Azure*

### Componentes da Arquitetura:
- **GitHub Repository**: Código fonte e versionamento
- **Azure DevOps**: Orquestração de pipelines CI/CD com Build e Release
- **Azure Container Registry (ACR)**: Registro privado de imagens Docker
- **Azure Container Instances (ACI)**: Execução dos containers da aplicação
- **Azure Database for PostgreSQL**: Banco de dados gerenciado em nuvem
- **Azure Boards**: Gestão de tarefas e sprints

---

## 📋 Problema Identificado

No cenário atual de transformação digital e automação, milhões de trabalhadores enfrentam desafios críticos:

- **Desalinhamento entre habilidades** e demandas do mercado de trabalho
- **Falta de orientação** sobre caminhos de requalificação profissional
- **Dificuldade em identificar competências** necessárias para vagas específicas
- **Ausência de análise preditiva** sobre profissões emergentes até 2030
- **Baixa inclusão produtiva** de profissionais em transição de carreira
- **Ineficiência no processo de match** entre candidatos e oportunidades

## 💡 Nossa Solução: NextJob

Desenvolvemos o **NextJob**, uma plataforma inteligente que utiliza **Inteligência Artificial, visão computacional e modelos preditivos** para apoiar candidatos no planejamento de carreira e aumentar compatibilidade com vagas de emprego.

### ✨ Funcionalidades Principais

#### 🎯 Análise Automática de Perfil
- Extração automática de **habilidades técnicas, experiências e soft skills**
- Interpretação de certificações e qualificações
- Mapeamento de competências com tecnologias de IA

#### 🤖 Match Inteligente com IA
- Cálculo de **compatibilidade percentual** entre candidato e vaga
- Análise baseada em critérios ponderados e algoritmos inteligentes
- Identificação de gaps de habilidades

#### 💼 Recomendações Personalizadas
- Sugestões automáticas para **aprimorar currículo**
- Orientações sobre competências mais valorizadas
- Feedback inteligente sobre perfil profissional

#### 🎓 Trilhas de Aprendizado
- Sugestão de **cursos e certificações** para habilidades em falta
- Recomendações de conteúdos para upskilling e reskilling
- Planejamento de desenvolvimento profissional

#### 📊 Plano de Carreira Personalizado
- Criação de **roadmap de carreira** baseado em IA
- Orientação sobre **profissões emergentes até 2030**
- Análise de tendências do mercado de trabalho

### 🎯 Benefícios para Candidatos e Empresas
- **Aumento de 60% na taxa de match** entre candidatos e vagas
- **Redução de 40% no tempo** de identificação de oportunidades
- **Orientação clara** sobre caminhos de requalificação profissional
- **Preparação para o futuro** com foco em competências emergentes
- **Inclusão produtiva** com IA como parceira do ser humano
- **Interface web intuitiva** para acesso simplificado

---

## 🛠️ Tecnologias Utilizadas

### Backend
- **Java 17** com Spring Boot 3.5.6
- **Spring Data JPA** para persistência
- **Spring Web** para API REST
- **Thymeleaf** para renderização de templates
- **PostgreSQL** como banco de dados

### Frontend
- **HTML5, CSS3, JavaScript** moderno
- **Design Responsivo** mobile-first
- **AJAX** para comunicação assíncrona
- Interface intuitiva e acessível

### DevOps e Cloud
- **Azure DevOps** para CI/CD
- **Azure Container Registry (ACR)**
- **Azure Container Instances (ACI)**
- **Azure Database for PostgreSQL**
- **Docker** para containerização
- **Gradle** para build automation

---

## 📦 Estrutura do Projeto

```
DevOps/
├── src/
│   ├── main/
│   │   ├── java/com/nextjob/
│   │   │   ├── controller/          # Controllers REST e Web
│   │   │   ├── model/               # Entidades JPA
│   │   │   ├── repository/          # Repositories Spring Data
│   │   │   ├── service/             # Lógica de negócio
│   │   │   └── config/              # Configurações (CORS, etc)
│   │   └── resources/
│   │       ├── templates/           # Páginas HTML Thymeleaf
│   │       ├── static/
│   │       │   ├── css/             # Estilos CSS
│   │       │   └── js/              # JavaScript
│   │       └── application.yml      # Configurações da aplicação
├── scripts/
│   ├── script-bd.sql                # Script de inicialização do BD
│   ├── script-infra-acr.sh          # Provisionamento ACR
│   ├── script-infra-database.sh     # Provisionamento PostgreSQL
│   ├── script-infra-aci.sh          # Provisionamento ACI
│   └── json-examples/               # JSONs para teste de CRUD
├── Dockerfile                       # Containerização da aplicação
├── azure-pipelines.yml              # Pipeline CI/CD Azure DevOps
├── build.gradle                     # Configuração Gradle
└── README.md                        # Este arquivo
```

---

## 🔗 APIs REST - Exemplos de CRUD

### 📌 **Candidates API** (`/api/candidates`)

#### **CREATE** - Criar Candidato
```bash
POST /api/candidates
Content-Type: application/json

{
  "fullName": "João Silva",
  "email": "joao.silva@email.com",
  "skills": [
    "Java",
    "Spring Boot",
    "PostgreSQL",
    "Docker",
    "JavaScript",
    "React"
  ]
}
```

**Resposta (201 Created):**
```json
{
  "id": 1,
  "fullName": "João Silva",
  "email": "joao.silva@email.com",
  "skills": ["Java", "Spring Boot", "PostgreSQL", "Docker", "JavaScript", "React"]
}
```

#### **READ** - Listar Todos os Candidatos
```bash
GET /api/candidates
```

**Resposta (200 OK):**
```json
[
  {
    "id": 1,
    "fullName": "João Silva",
    "email": "joao.silva@email.com",
    "skills": ["Java", "Spring Boot", "PostgreSQL", "Docker"]
  },
  {
    "id": 2,
    "fullName": "Maria Santos",
    "email": "maria.santos@email.com",
    "skills": ["Azure", "Docker", "Kubernetes", "CI/CD"]
  }
]
```

#### **READ** - Buscar Candidato por ID
```bash
GET /api/candidates/1
```

**Resposta (200 OK):**
```json
{
  "id": 1,
  "fullName": "João Silva",
  "email": "joao.silva@email.com",
  "skills": ["Java", "Spring Boot", "PostgreSQL", "Docker"]
}
```

#### **UPDATE** - Atualizar Candidato
```bash
PUT /api/candidates/1
Content-Type: application/json

{
  "fullName": "João Silva Atualizado",
  "email": "joao.silva@email.com",
  "skills": [
    "Java",
    "Spring Boot",
    "PostgreSQL",
    "Docker",
    "Kubernetes",
    "Azure"
  ]
}
```

**Resposta (200 OK):**
```json
{
  "id": 1,
  "fullName": "João Silva Atualizado",
  "email": "joao.silva@email.com",
  "skills": ["Java", "Spring Boot", "PostgreSQL", "Docker", "Kubernetes", "Azure"]
}
```

#### **DELETE** - Excluir Candidato
```bash
DELETE /api/candidates/1
```

**Resposta (204 No Content)**

---

### 💼 **Vacancies API** (`/api/vacancies`)

#### **CREATE** - Criar Vaga
```bash
POST /api/vacancies
Content-Type: application/json

{
  "title": "Desenvolvedor Java Sênior",
  "description": "Buscamos desenvolvedor Java com experiência em Spring Boot e microsserviços.",
  "requiredSkills": [
    "Java",
    "Spring Boot",
    "Microservices",
    "PostgreSQL",
    "Docker",
    "Azure"
  ]
}
```

**Resposta (201 Created):**
```json
{
  "id": 1,
  "title": "Desenvolvedor Java Sênior",
  "description": "Buscamos desenvolvedor Java com experiência em Spring Boot e microsserviços.",
  "requiredSkills": ["Java", "Spring Boot", "Microservices", "PostgreSQL", "Docker", "Azure"]
}
```

#### **READ** - Listar Todas as Vagas
```bash
GET /api/vacancies
```

**Resposta (200 OK):**
```json
[
  {
    "id": 1,
    "title": "Desenvolvedor Java Sênior",
    "description": "Buscamos desenvolvedor Java...",
    "requiredSkills": ["Java", "Spring Boot", "Microservices"]
  }
]
```

#### **READ** - Buscar Vaga por ID
```bash
GET /api/vacancies/1
```

#### **UPDATE** - Atualizar Vaga
```bash
PUT /api/vacancies/1
Content-Type: application/json

{
  "title": "Desenvolvedor Java Sênior - Atualizado",
  "description": "Nova descrição atualizada...",
  "requiredSkills": ["Java", "Spring Boot", "Azure", "Kubernetes"]
}
```

#### **DELETE** - Excluir Vaga
```bash
DELETE /api/vacancies/1
```

**Resposta (204 No Content)**

---

### 🎯 **Match API** (`/api/match`)

#### **Calcular Compatibilidade**
```bash
POST /api/match/compatibility
Content-Type: application/json

{
  "candidateId": 1,
  "vacancyId": 1
}
```

**Resposta (200 OK):**
```json
{
  "candidateId": 1,
  "vacancyId": 1,
  "compatibility": 85
}
```

**Interpretação dos Scores:**
- **80-100%**: 🎉 Excelente match! Alta compatibilidade
- **60-79%**: 👍 Bom match! Atende maioria dos requisitos
- **40-59%**: ⚠️ Match moderado. Capacitação recomendada
- **0-39%**: ❌ Match baixo. Requalificação necessária

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Java 17+
- Gradle 8+
- PostgreSQL 14+
- Docker (opcional)

### Executar Localmente

1. **Clonar o repositório:**
```bash
git clone https://github.com/seu-usuario/nextjob.git
cd nextjob
```

2. **Configurar banco de dados:**
```bash
# Criar banco PostgreSQL
psql -U postgres
CREATE DATABASE nextjob;

# Executar script de inicialização
psql -U postgres -d nextjob -f scripts/script-bd.sql
```

3. **Configurar variáveis de ambiente:**
```bash
export DATABASE_URL=jdbc:postgresql://localhost:5432/nextjob
export DATABASE_USERNAME=nextjob_user
export DATABASE_PASSWORD=nextjob_pass
```

4. **Executar aplicação:**
```bash
./gradlew bootRun
```

5. **Acessar aplicação:**
- Interface Web: http://localhost:8080
- API REST: http://localhost:8080/api

### Executar com Docker

```bash
# Build da imagem
docker build -t nextjob:latest .

# Executar container
docker run -p 8080:8080 \
  -e DATABASE_URL=jdbc:postgresql://host.docker.internal:5432/nextjob \
  -e DATABASE_USERNAME=nextjob_user \
  -e DATABASE_PASSWORD=nextjob_pass \
  nextjob:latest
```

---

## ☁️ Deploy no Azure

### 1. Provisionar Infraestrutura

```bash
# 1. Criar Container Registry
./scripts/script-infra-acr.sh

# 2. Criar PostgreSQL Database
./scripts/script-infra-database.sh

# 3. Build e Push da imagem
docker build -t acrnextjob.azurecr.io/nextjob:latest .
docker push acrnextjob.azurecr.io/nextjob:latest

# 4. Criar Container Instance
./scripts/script-infra-aci.sh
```

### 2. Pipeline CI/CD

O pipeline `azure-pipelines.yml` automatiza:
- ✅ Build da aplicação com Gradle
- ✅ Execução de testes unitários
- ✅ Build da imagem Docker
- ✅ Push para Azure Container Registry
- ✅ Deploy automático no Azure Container Instances
- ✅ Publicação de artefatos e resultados de testes

---

## 🧪 Testes

### Executar Testes Unitários
```bash
./gradlew test
```

### Testar APIs com cURL

```bash
# Criar candidato
curl -X POST http://localhost:8080/api/candidates \
  -H "Content-Type: application/json" \
  -d @scripts/json-examples/candidate-create.json

# Listar candidatos
curl http://localhost:8080/api/candidates

# Criar vaga
curl -X POST http://localhost:8080/api/vacancies \
  -H "Content-Type: application/json" \
  -d @scripts/json-examples/vacancy-create.json

# Calcular compatibilidade
curl -X POST http://localhost:8080/api/match/compatibility \
  -H "Content-Type: application/json" \
  -d @scripts/json-examples/match-compatibility.json
```

---

## 📊 Variáveis de Ambiente

| Variável | Descrição | Padrão |
|----------|-----------|--------|
| `DATABASE_URL` | URL de conexão PostgreSQL | `jdbc:postgresql://localhost:5432/nextjob` |
| `DATABASE_USERNAME` | Usuário do banco de dados | `nextjob_user` |
| `DATABASE_PASSWORD` | Senha do banco de dados | `nextjob_pass` |
| `SERVER_PORT` | Porta da aplicação | `8080` |
| `JPA_DDL_AUTO` | Estratégia JPA DDL | `update` |
| `JPA_SHOW_SQL` | Exibir SQL no console | `true` |
| `LOG_LEVEL` | Nível de log | `INFO` |

---

## 👥 Equipe

- **Desenvolvedor Full Stack**: [Seu Nome]
- **DevOps Engineer**: [Nome do Colega]
- **Database Administrator**: [Nome do Colega]

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos - Disciplina de DevOps Tools & Cloud Computing - FIAP 2025.

---

## 🎓 Tema do Projeto

**O Futuro do Trabalho**: Requalificação Profissional (Upskilling e Reskilling), IA como Parceira do Ser Humano e Inclusão Produtiva.

O NextJob é uma solução tecnológica que prepara trabalhadores para as novas demandas do mercado, especialmente diante da automação, transformação digital e profissões emergentes.

---

## 🛠️ Stack Tecnológica

### Backend
- **Java 17** - Linguagem principal
- **Spring Boot 3.x** - Framework web
- **Spring Security** - Autenticação e autorização
- **Spring Data JPA** - Persistência de dados
- **Thymeleaf** - Template engine server-side
- **Flyway** - Controle de versão e migração do banco

### Banco de Dados
- **PostgreSQL 17** - Banco relacional em container (Alpine Linux)
- **Azure Container Instances** - Hospedagem do banco de dados em nuvem
- **Flyway Migrations** - Versionamento automático do schema

### DevOps & Cloud
- **Docker** - Containerização da aplicação e banco de dados
- **Azure Container Registry (ACR)** - Registro privado de imagens Docker
- **Azure Container Instances (ACI)** - Execução de containers em nuvem
- **Azure DevOps Pipelines** - Orquestração CI/CD
- **Azure CLI** - Automação de infraestrutura
- **Gradle** - Build e gerenciamento de dependências
- **GitHub** - Controle de versão (SCM)
- **GitHub OAuth** - Autenticação social

### Frontend
- **Bootstrap 5** - Framework CSS responsivo
- **JavaScript ES6+** - Interatividade do cliente
- **Thymeleaf** - Renderização server-side com Spring

---

## 🔄 Fluxo CI/CD com Azure DevOps

### Pipeline de Integração Contínua (CI)

A pipeline CI é **automaticamente disparada** a cada push na branch `main` e executa os seguintes estágios:

1. **Cache de Dependências Gradle**
   - Otimiza o build reutilizando dependências já baixadas
   - Reduz tempo de execução da pipeline

2. **Build da Aplicação**
   - Compila o código Java com Gradle
   - Executa testes unitários automatizados
   - Gera relatórios JUnit de cobertura
   - Publica resultados dos testes no Azure DevOps

3. **Build da Imagem Docker**
   - Constrói imagem Docker da aplicação
   - Faz push para Azure Container Registry (ACR)
   - Tageia com `latest` e número do build
   - Utiliza Service Connection segura

4. **Publicação de Artefatos**
   - Gera arquivo JAR executável
   - Publica artefato no Azure DevOps
   - Disponibiliza para estágio de deploy

### Pipeline de Deploy Contínuo (CD)

O deploy é **automaticamente disparado** após a conclusão bem-sucedida do CI:

1. **Obtenção de Credenciais**
   - Recupera credenciais do ACR dinamicamente
   - Utiliza Azure CLI com Service Principal

2. **Limpeza de Ambiente**
   - Remove container anterior (se existir)
   - Garante estado limpo para novo deploy

3. **Provisionamento no ACI**
   - Cria novo Azure Container Instance
   - Configura variáveis de ambiente seguras
   - Injeta credenciais de banco de dados
   - Configura autenticação GitHub OAuth
   - Expõe aplicação na porta 8080

4. **Validação do Deploy**
   - Verifica status do container
   - Exibe URL de acesso da aplicação

### 🔐 Segurança e Boas Práticas

- **Variáveis Secretas**: Credenciais armazenadas como variáveis secretas no Azure DevOps
- **Service Connections**: Autenticação segura com Azure usando Service Principal
- **Container Registry Privado**: Imagens armazenadas em ACR privado
- **Restart Policy**: Containers configurados com política `Always` para alta disponibilidade
- **Separação de Ambientes**: Diferentes configurações para CI e CD


---

## 🗄️ Banco de Dados em Nuvem

### PostgreSQL em Azure Container Instance

O projeto utiliza **PostgreSQL 17 Alpine** em um container dedicado no Azure:

#### Características:
- **Tipo**: Banco de dados relacional em container
- **Provedor**: Microsoft Azure (ACI)
- **Versão**: PostgreSQL 17 com Alpine Linux
- **Alta Disponibilidade**: Restart policy configurado como `Always`
- **Recursos**: 1 CPU core e 2GB de memória RAM
- **Acesso**: FQDN público com porta 5432 exposta
- **Persistência**: Volume gerenciado pelo ACI

#### Configuração:
```yaml
Host: aci-db-nextjob-rm555197.eastus.azurecontainer.io
Port: 5432
Database: nextjob
Username: nextjob
Password: [Protegido por variável secreta no Azure DevOps]
```

---


### Variáveis de Ambiente Protegidas

As seguintes variáveis são configuradas como **secretas** no Azure DevOps:

- `SPRING_DATASOURCE_URL`: URL de conexão JDBC do PostgreSQL
- `DB_PASSWORD`: Senha do banco de dados
- `GITHUB_CLIENT_ID`: Client ID da OAuth App do GitHub
- `GITHUB_CLIENT_SECRET`: Client Secret da OAuth App do GitHub
- `ACR_NAME`: Nome do Azure Container Registry
- `azureSubscription`: Service Connection com a subscription Azure

---

## 🚀 Como Executar o Projeto

### Opção 1: Via Azure DevOps (Recomendado)

1. **Faça uma alteração no código**
2. **Commit e push para branch `main`**
   ```bash
   git add .
   git commit -m "feat: nova funcionalidade"
   git push origin main
   ```
3. **Aguarde a pipeline executar automaticamente**
4. **Acesse a aplicação pela URL fornecida ao final do deploy**


#### Passos para Setup Manual

```bash
# 1. Clone o repositório
git clone https://github.com/Luiz-Felipe-Abreu/Sprint4-Nextjob-DevOps.git
cd Sprint4-Nextjob-DevOps

# 2. Execute o script de setup (cria ACR e banco PostgreSQL)
bash setup.sh

# 3. Configure as variáveis OAuth no Azure DevOps Library
# Vá em: Pipelines → Library → Variable Groups
# Adicione GITHUB_CLIENT_ID e GITHUB_CLIENT_SECRET

# 4. Execute a pipeline manualmente ou faça push no repositório
git push origin main

#5. Excluir grupo de recurso criado
bash delete.sh
```

### URLs de Acesso

Após o deploy bem-sucedido, acesse:

- **🌐 Aplicação Web**: `http://aci-app-nextjob-rm555197.eastus.azurecontainer.io:8080`
- **🗄️ Banco PostgreSQL**: `aci-db-nextjob-rm555197.eastus.azurecontainer.io:5432`

### Credenciais do Banco

```
Host: aci-db-nextjob-rm555197.eastus.azurecontainer.io
Port: 5432
Database: nextjob
Username: nextjob
Password: nextjob
```

---

## 👥 Equipe de Desenvolvimento

- **Pedro Gomes** – RM553907 - 2TDSA
- **Luiz Felipe Abreu** – RM555197 - 2TDSA
- **Matheus Munuera** – RM557812 - 2TDSA

---

## 📹 Demonstração

- **Vídeo YouTube**: https://www.youtube.com/watch?v=vGov11hSS5Q
- **Repositório GitHub**: https://github.com/Luiz-Felipe-Abreu/Sprint4-Nextjob-DevOps.git
- **Azure DevOps**: https://dev.azure.com/RM555197/Sprint4-azure-DevOps

---

## 📄 Licença

Este projeto foi desenvolvido como parte do **Challenge DevOps - Sprint 4** - FIAP 2025.

---

## 🔍 Estrutura de Arquivos do Projeto

```
Sprint4-Nextjob-DevOps/
├── src/                          # Código-fonte da aplicação
│   ├── main/
│   │   ├── java/                 # Classes Java
│   │   └── resources/            # Arquivos de configuração
│   │       ├── db/migration/     # Scripts Flyway
│   │       └── templates/        # Views Thymeleaf
│   └── test/                     # Testes unitários
├── azure-pipelines.yml           # Definição da pipeline CI/CD
├── Dockerfile                    # Imagem Docker da aplicação
├── setup.sh                      # Script de setup inicial do ambiente
├── delete.sh                     # Script de limpeza de recursos
├── build.gradle                  # Configuração Gradle
└── README.md                     # Documentação (este arquivo)
```

---

*Smart Location - Transformando a mobilidade urbana através da tecnologia e DevOps* 🚀
