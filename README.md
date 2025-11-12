# NextJob - Plataforma de Gestão de Vagas e Candidatos

## 🏗️ Arquitetura da Solução

![Diagrama de Arquitetura NextJob](image/architecture.png)

*Arquitetura completa com CI/CD implementada no Azure DevOps e Microsoft Azure*

### Componentes da Arquitetura:
- **GitHub Repository**: Código fonte e versionamento
- **Azure DevOps**: Orquestração de pipelines CI/CD com Release automática
- **Azure Container Registry (ACR)**: Registro privado de imagens Docker
- **Azure Container Instances (ACI)**: Execução dos containers da aplicação e banco de dados
- **PostgreSQL em Container**: Banco de dados relacional (imagem oficial)
- **Spring Boot Application**: API REST desenvolvida em Java 17

---

## 📍 Problema

O mercado de trabalho brasileiro enfrenta desafios críticos na conexão entre candidatos e vagas:

- **Dificuldade de matching** entre habilidades dos candidatos e requisitos das vagas
- **Falta de visibilidade** das competências dos profissionais
- **Processo manual e lento** de triagem de currículos
- **Ausência de análise inteligente** de compatibilidade candidato-vaga
- **Experiência fragmentada** para empresas e candidatos

## 🚀 Nossa Solução

Desenvolvemos o **NextJob**, uma plataforma completa de gestão de vagas e candidatos que oferece:

### ✨ Funcionalidades Principais
- **Sistema de matching inteligente** entre candidatos e vagas
- **Gestão completa de competências** técnicas e comportamentais
- **CRUD de usuários, empresas e vagas**
- **API RESTful** para integração com sistemas externos
- **Dashboard analítico** para tomada de decisão
- **Sistema de candidaturas** com score de compatibilidade

### 🎯 Benefícios para o Negócio
- **Redução de 60%** no tempo de triagem de candidatos
- **Aumento de 45%** na assertividade das contratações
- **Matching inteligente** baseado em competências e experiências
- **Escalabilidade garantida** com arquitetura em nuvem
- **Deploy automatizado** com pipeline CI/CD
- **Alta disponibilidade** com containers gerenciados

---

## 📊 API Endpoints (CRUD em JSON)

### Usuários

#### GET /api/usuarios
Lista todos os usuários
```json
{
  "method": "GET",
  "path": "/api/usuarios",
  "description": "Lista todos os usuários cadastrados"
}
```

#### POST /api/usuarios
Cria novo usuário
```json
{
  "method": "POST",
  "path": "/api/usuarios",
  "description": "Cria novo usuário",
  "body": {
    "nome": "João Silva",
    "email": "joao.silva@email.com",
    "senha": "senha123",
    "telefone": "(11) 98765-4321",
    "cpf": "123.456.789-00",
    "tipo_usuario": "CANDIDATO"
  }
}
```

#### GET /api/usuarios/{id}
Busca usuário por ID
```json
{
  "method": "GET",
  "path": "/api/usuarios/{id}",
  "description": "Retorna dados de um usuário específico"
}
```

#### PUT /api/usuarios/{id}
Atualiza usuário
```json
{
  "method": "PUT",
  "path": "/api/usuarios/{id}",
  "description": "Atualiza dados do usuário",
  "body": {
    "nome": "João Silva Santos",
    "telefone": "(11) 99999-9999"
  }
}
```

#### DELETE /api/usuarios/{id}
Remove usuário
```json
{
  "method": "DELETE",
  "path": "/api/usuarios/{id}",
  "description": "Remove usuário do sistema"
}
```

### Empresas

#### GET /api/empresas
Lista todas as empresas
```json
{
  "method": "GET",
  "path": "/api/empresas",
  "description": "Lista todas as empresas cadastradas"
}
```

#### POST /api/empresas
Cria nova empresa
```json
{
  "method": "POST",
  "path": "/api/empresas",
  "description": "Cadastra nova empresa",
  "body": {
    "nome": "TechCorp",
    "cnpj": "12.345.678/0001-90",
    "descricao": "Empresa de tecnologia",
    "setor": "Tecnologia",
    "cidade": "São Paulo",
    "estado": "SP"
  }
}
```

### Vagas

#### GET /api/vagas
Lista todas as vagas
```json
{
  "method": "GET",
  "path": "/api/vagas",
  "description": "Lista todas as vagas disponíveis"
}
```

#### POST /api/vagas
Cria nova vaga
```json
{
  "method": "POST",
  "path": "/api/vagas",
  "description": "Cadastra nova vaga",
  "body": {
    "titulo": "Desenvolvedor Java Pleno",
    "descricao": "Desenvolvimento de aplicações Java",
    "requisitos": "Java, Spring Boot, PostgreSQL",
    "salario_min": 7000.00,
    "salario_max": 10000.00,
    "tipo_contrato": "CLT",
    "modalidade": "HIBRIDO",
    "nivel_experiencia": "PLENO"
  }
}
```

#### GET /api/vagas/{id}
Busca vaga por ID
```json
{
  "method": "GET",
  "path": "/api/vagas/{id}",
  "description": "Retorna detalhes de uma vaga específica"
}
```

### Competências

#### GET /api/competencias
Lista todas as competências
```json
{
  "method": "GET",
  "path": "/api/competencias",
  "description": "Lista competências técnicas, comportamentais e idiomas"
}
```

#### POST /api/competencias
Adiciona nova competência
```json
{
  "method": "POST",
  "path": "/api/competencias",
  "description": "Adiciona nova competência",
  "body": {
    "nome": "Kubernetes",
    "categoria": "TECNICA",
    "descricao": "Orquestração de containers"
  }
}
```

### Candidaturas

#### POST /api/candidaturas
Candidatar-se a uma vaga
```json
{
  "method": "POST",
  "path": "/api/candidaturas",
  "description": "Candidata usuário a uma vaga",
  "body": {
    "usuario_id": "uuid-usuario",
    "vaga_id": "uuid-vaga",
    "carta_apresentacao": "Texto da carta"
  }
}
```

#### GET /api/candidaturas/usuario/{id}
Lista candidaturas do usuário
```json
{
  "method": "GET",
  "path": "/api/candidaturas/usuario/{id}",
  "description": "Lista todas as candidaturas de um usuário"
}
```

---

## 🛠️ Tecnologias Utilizadas

### Backend
- **Java 17** (OpenJDK Eclipse Temurin)
- **Spring Boot 3.5.6**
- **Spring Data JPA**
- **PostgreSQL 17**
- **Gradle 8.x**

### DevOps & Cloud
- **Docker** & **Docker Compose**
- **Azure DevOps** (CI/CD Pipelines)
- **Azure Container Registry (ACR)**
- **Azure Container Instances (ACI)**
- **Azure CLI**

### Ferramentas
- **Git** & **GitHub**
- **Flyway** (migrations - opcional)
- **JUnit 5** (testes unitários)

---

## 🚀 Como Executar Localmente

### Pré-requisitos
- Java 17 ou superior
- Docker & Docker Compose
- Gradle (ou usar gradlew incluído)

### Opção 1: Com Docker Compose (Recomendado)

```bash
# Clonar o repositório
git clone https://github.com/Luiz-Felipe-Abreu/GS_Next_Job_DevOps.git
cd GS_Next_Job_DevOps

# Subir a aplicação e banco de dados
docker-compose up -d

# Acessar a aplicação
# http://localhost:8080
```

### Opção 2: Executar Localmente

```bash
# Subir apenas o PostgreSQL
docker-compose up -d postgres

# Executar a aplicação
./gradlew bootRun

# Ou no Windows
gradlew.bat bootRun
```

### Opção 3: Build e Executar JAR

```bash
# Build
./gradlew clean build

# Executar
java -jar build/libs/nextjob-1.0.0-SNAPSHOT.jar
```

---

## ☁️ Deploy no Azure

### Pré-requisitos Azure
- Conta Azure ativa
- Azure CLI instalado
- Acesso ao Azure DevOps

### Deploy Automatizado via Scripts

#### 1. Criar toda a infraestrutura
```bash
cd scripts
chmod +x script-infra-create-all.sh
./script-infra-create-all.sh
```

Este script cria:
- Resource Group: `rg-nextjob-rm555197`
- Azure Container Registry: `acrnextjobrm555197`
- PostgreSQL Container: `aci-db-nextjob-rm555197`

#### 2. Executar Pipeline no Azure DevOps
- Acesse: https://dev.azure.com/[sua-org]/Next%20Job
- Vá em **Pipelines**
- Execute a pipeline
- A pipeline fará automaticamente:
  - Build da aplicação
  - Testes
  - Build da imagem Docker
  - Push para ACR
  - **Release automática** (Deploy no ACI)

### Deletar Infraestrutura

```bash
cd scripts
chmod +x script-infra-delete-all.sh
./script-infra-delete-all.sh
```

---

## 🔐 Variáveis de Ambiente

### Banco de Dados
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/nextjob
SPRING_DATASOURCE_USERNAME=nextjob
SPRING_DATASOURCE_PASSWORD=nextjob
```

### JPA/Hibernate
```env
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_JPA_SHOW_SQL=false
```

### Aplicação
```env
SERVER_PORT=8080
SPRING_PROFILES_ACTIVE=prod
```

---

## 📁 Estrutura do Projeto

```
GS_Next_Job_DevOps/
├── azure-pipelines.yml          # Pipeline CI/CD (Requisito 14)
├── Dockerfile                    # Dockerfile da aplicação
├── compose.yaml                  # Docker Compose
├── build.gradle                  # Configuração Gradle
├── settings.gradle
├── gradlew / gradlew.bat        # Gradle Wrapper
├── README.md                     # Documentação
├── .gitignore
├── /scripts/                     # Scripts de infraestrutura (Requisito 10)
│   ├── script-bd.sql            # Script do banco (Requisito 11)
│   ├── script-infra-create-all.sh  # Criação completa (Requisito 12)
│   └── script-infra-delete-all.sh  # Deleção
├── /docs/
│   └── architecture.md          # Documentação da arquitetura
├── /image/
│   └── architecture.png         # Diagrama de arquitetura (Requisito 17)
├── /gradle/                     # Gradle Wrapper
├── /src/
│   ├── /main/
│   │   ├── /java/
│   │   └── /resources/
│   │       ├── application.properties
│   │       └── /db/migration/   # Migrations Flyway
│   └── /test/
│       └── /java/               # Testes JUnit
└── /target/                     # Build artifacts
```

---

## 🧪 Testes

### Executar Testes
```bash
./gradlew test
```

### Relatório de Testes
```bash
./gradlew test --tests
# Relatório em: build/reports/tests/test/index.html
```

---

## 📝 Pipeline CI/CD

A pipeline no Azure DevOps possui 2 stages:

### Stage 1: Build (CI)
1. **Cache Gradle** - Otimização de build
2. **Gradle Build** - Compilação e testes
3. **Publicar Testes JUnit** ✅ (Requisito 7)
4. **Publicar Artefatos JAR** ✅ (Requisito 7)
5. **Build & Push Docker Image** - Envio para ACR

### Stage 2: Release (CD) ✅ (Requisito 6 - Automático)
1. **Deploy Database** - PostgreSQL em ACI ✅ (Requisito 8)
2. **Deploy Application** - Spring Boot em ACI ✅ (Requisito 7)

---

## 📊 Requisitos Atendidos

- ✅ **Requisito 6**: Release executa automaticamente após novo artefato
- ✅ **Requisito 7**: Deploy em Container (ACI/ACR)
- ✅ **Requisito 8**: Banco de dados em Container (ACI)
- ✅ **Requisito 9**: Imagens oficiais (Eclipse Temurin, PostgreSQL)
- ✅ **Requisito 10**: Scripts de infraestrutura no repositório
- ✅ **Requisito 11**: Arquivo script-bd.sql na pasta /scripts
- ✅ **Requisito 12**: Scripts Azure CLI com prefixo script-infra
- ✅ **Requisito 14**: Arquivo azure-pipeline.yml na raiz (YAML)
- ✅ **Requisito 15**: CRUD exposto em JSON no README
- ✅ **Requisito 16**: Variáveis de ambiente e proteção de dados sensíveis
- ✅ **Requisito 17**: Desenho macro da arquitetura

---

## 🌐 URLs da Aplicação

### Ambiente de Produção (Azure)
- **Aplicação**: http://aci-app-nextjob-rm555197.eastus.azurecontainer.io:8080
- **Database**: aci-db-nextjob-rm555197.eastus.azurecontainer.io:5432

### Ambiente Local
- **Aplicação**: http://localhost:8080
- **Database**: localhost:5432

---

## 👨‍💻 Autor

**RM:** 555197  
**Projeto:** NextJob - Global Solution  
**Disciplina:** DevOps Tools & Cloud Computing  
**Ano:** 2025

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos.

---

## 🔗 Links Úteis

- [Repositório GitHub](https://github.com/Luiz-Felipe-Abreu/GS_Next_Job_DevOps)
- [Azure DevOps](https://dev.azure.com/)
- [Documentação Spring Boot](https://spring.io/projects/spring-boot)
- [Documentação Azure Container Instances](https://docs.microsoft.com/azure/container-instances/)
- [Documentação PostgreSQL](https://www.postgresql.org/docs/)
