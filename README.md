# NextJob API - Sistema de Recrutamento Inteligente 🎯

Sistema completo de análise de currículos e recomendação de planos de carreira, desenvolvido com **Java + Spring Boot** e infraestrutura na **Azure** utilizando práticas modernas de **DevOps**.

---
## Participantes

- Pedro Gomes - RM 553907
- Luiz Felipe Abreu - RM 555197
- Matheus Munuera - RM 557812

---

## 📖 Sobre o Projeto

O **NextJob** é uma plataforma inteligente de recrutamento que utiliza **Inteligência Artificial** para analisar currículos e recomendar planos de carreira personalizados. O sistema integra autenticação OAuth2 (GitHub), processamento de documentos, análise por IA usando a **Groq API** e oferece suporte multilíngue.

### 🎯 Principais Funcionalidades

- **Upload e Análise de Currículos**: Suporte para múltiplos formatos (PDF, DOC, TXT)
- **IA Generativa**: Análise automática de currículos usando modelo **LLaMA 3.3 70B** via Groq
- **Autenticação Segura**: OAuth2 (GitHub) e autenticação tradicional com Spring Security
- **Planos de Carreira**: Recomendações personalizadas de cursos e trilhas de aprendizado
- **Internacionalização**: Suporte completo para Português (BR) e Inglês (US)
- **Cache Inteligente**: Otimização de performance com Spring Cache
- **Banco de Dados Robusto**: PostgreSQL com migrações automatizadas via Flyway
- **Observabilidade**: Métricas Prometheus + Spring Actuator para monitoramento

---

## 🛠 Tecnologias Utilizadas

### Backend & Framework
- **Java 21** - Linguagem principal com recursos modernos
- **Spring Boot 3.5.7** - Framework base da aplicação
- **Spring Security** - Autenticação e autorização
- **Spring Data JPA** - Abstração de persistência com Hibernate
- **Spring Cache** - Sistema de cache para otimização
- **Spring Actuator** - Endpoints de health check e métricas
- **OAuth2 Client** - Integração com GitHub para login social
- **Thymeleaf** - Engine de templates para renderização HTML
- **Lombok** - Redução de código boilerplate

### Banco de Dados
- **PostgreSQL 17** - Banco relacional para produção
- **H2 Database** - Banco em memória para desenvolvimento/testes
- **Flyway** - Controle de versionamento do schema do banco

### Build & Qualidade
- **Gradle 8+** - Ferramenta de build com Gradle Wrapper incluído
- **JUnit 5** - Framework de testes unitários
- **Spring Security Test** - Testes de segurança

### DevOps & Cloud
- **Docker** - Containerização da aplicação
- **Docker Compose** - Orquestração local de containers
- **Azure Container Registry (ACR)** - Registro privado de imagens Docker
- **Azure Container Instances (ACI)** - Execução serverless de containers
- **Azure DevOps Pipelines** - CI/CD automatizado
- **Bash Scripts** - Automação de infraestrutura (IaC)

### Inteligência Artificial
- **Groq API** - Plataforma de IA para processamento de linguagem natural
- **LLaMA 3.3 70B** - Modelo de linguagem para análise de currículos
- **Jackson** - Serialização/deserialização JSON

### Observabilidade
- **Micrometer** - Biblioteca de métricas
- **Prometheus** - Sistema de monitoramento e alertas
- **Spring Boot Actuator** - Endpoints de gerenciamento e saúde

---

## 📋 Pré-requisitos

Antes de iniciar, certifique-se de ter instalado:

- **Java 21 ou superior** ([Download](https://adoptium.net/))
- **Docker** e **Docker Compose** ([Download](https://www.docker.com/))
- **Azure CLI** ([Instruções](https://learn.microsoft.com/cli/azure/install-azure-cli))
- **Git** ([Download](https://git-scm.com/))
- **Conta Azure ativa** com permissões para criar recursos
- **Conta GitHub** (para configurar OAuth2)

---

## 🚀 Como Rodar o Projeto

### 🔧 Desenvolvimento Local

#### 1. Clonar o Repositório
```bash
git clone https://github.com/Luiz-Felipe-Abreu/GS_Next_Job_DevOps.git
cd GS_Next_Job_DevOps
```

#### 2. Configurar Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
# Banco de Dados
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/nextjob
SPRING_DATASOURCE_USERNAME=nextjob_user
SPRING_DATASOURCE_PASSWORD=nextjob_pass

# Groq AI
GROQ_API_KEY=sua_chave_groq_aqui
GROQ_API_URL=https://api.groq.com/openai/v1/chat/completions
GROQ_MODEL=llama-3.3-70b-versatile

# OAuth2 GitHub
GITHUB_CLIENT_ID=seu_client_id_aqui
GITHUB_CLIENT_SECRET=seu_client_secret_aqui
```

> **Como obter as chaves:**
> - **Groq**: Crie conta em [console.groq.com](https://console.groq.com) e gere uma API key
> - **GitHub OAuth**: Vá em Settings → Developer Settings → OAuth Apps → New OAuth App

#### 3. Subir o Banco de Dados Local

Use o Docker Compose para iniciar o PostgreSQL:

```bash
docker-compose up -d
```

Isso irá:
- Criar um container PostgreSQL na porta `5432`
- Criar automaticamente o banco `nextjob`
- Configurar usuário e senha definidos no `docker-compose.yml`

#### 4. Executar a Aplicação

```bash
# Com Gradle Wrapper (recomendado)
./gradlew bootRun

# Ou compilar e executar o JAR
./gradlew build
java -jar build/libs/NextJobAPI-0.0.1-SNAPSHOT.jar
```

A aplicação estará disponível em: **http://localhost:8080**

#### 5. Verificar Funcionamento

```bash
# Health Check
curl http://localhost:8080/actuator/health

# Métricas
curl http://localhost:8080/actuator/prometheus
```

---

## ☁️ Deploy no Azure

O projeto inclui scripts Bash para **provisionamento automático** de toda a infraestrutura Azure necessária.

### 🚀 Script: `setup.sh`

Este script automatiza a criação completa da infraestrutura:

```bash
bash setup.sh
```

#### O que o script faz:

1. **Cria Resource Group** (`rg-nextjob`)
   - Agrupa todos os recursos Azure do projeto
   - Região padrão: `East US`

2. **Provisiona Azure Container Registry (ACR)** (`acrnextjob`)
   - Registro privado para armazenar imagens Docker
   - SKU: Basic (suficiente para desenvolvimento)
   - Habilita usuário admin para autenticação

3. **Autentica no ACR**
   - Faz login automático no registro

4. **Importa Imagem PostgreSQL**
   - Faz pull da imagem oficial `postgres:17-alpine`
   - Faz tag com o nome do ACR
   - Envia (push) para o ACR

5. **Cria Container do Banco de Dados**
   - Provisiona Azure Container Instance (ACI) para PostgreSQL
   - Configurações:
     - **Nome**: `aci-db-nextjob-rm555197`
     - **CPU**: 1 core
     - **Memória**: 2 GB
     - **Porta**: 5432 (exposta publicamente)
     - **DNS**: `aci-db-nextjob-rm555197.eastus.azurecontainer.io`
     - **Restart Policy**: Always (reinicia automaticamente em caso de falha)
   - Variáveis de ambiente configuradas:
     - `POSTGRES_DB=nextjob`
     - `POSTGRES_USER=nextjob`
     - `POSTGRES_PASSWORD=nextjob`

6. **Limpa containers anteriores**
   - Remove instâncias existentes para evitar conflitos de DNS

#### Variáveis Configuráveis no Script:

```bash
ACR_NAME="acrnextjob"              # Nome do Container Registry
RG_NAME="rg-nextjob"                # Nome do Resource Group
IMAGE_NAME="appnextjob:latest"      # Nome da imagem da aplicação
LOCATION="eastus"                   # Região Azure
RM="555197"                         # Identificador único (RM acadêmico)
DB_NAME="nextjob"                   # Nome do banco de dados
DB_USER="nextjob"                   # Usuário do banco
DB_PASSWORD="nextjob"               # Senha do banco
```

---

### 🗑️ Script: `delete.sh`

Remove **completamente** toda a infraestrutura criada:

```bash
bash delete.sh
```

#### O que o script faz:

- Deleta o **Resource Group** inteiro (`rg-nextjob`)
- Remove **automaticamente** todos os recursos associados:
  - Azure Container Registry (ACR)
  - Azure Container Instances (aplicação e banco)
  - Networks e configurações de DNS
  - Todos os dados armazenados

> ⚠️ **ATENÇÃO**: Esta operação é **IRREVERSÍVEL**! Todos os dados serão perdidos permanentemente.

**Quando usar:**
- Após terminar os testes
- Para limpar ambiente e evitar custos
- Antes de recriar a infraestrutura do zero

---

## 🔄 DevOps: Pipeline CI/CD

O arquivo `azure-pipelines.yml` define um pipeline completo de **Integração Contínua** e **Entrega Contínua**.

### 📦 Stage 1: Build (CI)

Responsável por compilar o código e gerar artefatos:

#### Job 1: Gradle Build
1. **Cache do Gradle**
   - Armazena dependências para acelerar builds futuros
   - Reduz tempo de compilação em até 70%

2. **Compilação Java**
   - Usa Gradle Wrapper (`./gradlew`)
   - Java 21 com JDK configurado
   - Profile ativo: `dev`
   - Pula testes para build mais rápido (`-x test`)
   - Utiliza build cache do Gradle

3. **Geração de Artefatos**
   - Copia JAR gerado para staging area
   - Publica artefato chamado `nextjobApp`

#### Job 2: Build e Push Docker
1. **Autenticação**
   - Login no ACR usando Azure CLI
   - Credenciais gerenciadas via Service Principal

2. **Build Multi-Stage**
   - Constrói imagem Docker otimizada
   - Duas tags criadas:
     - `latest` (sempre aponta para versão mais recente)
     - `$(Build.BuildId)` (identificador único do build)

3. **Push para ACR**
   - Envia ambas as tags para o registro
   - Imagens ficam disponíveis para deploy

### 🚀 Stage 2: Deploy (CD)

Realiza o deploy automatizado no Azure Container Instances:

1. **Preparação**
   - Define subscription Azure correta
   - Obtém credenciais do ACR

2. **Limpeza de Container Anterior**
   - Remove container existente (se houver)
   - Previne conflitos de DNS e recursos
   - Aguarda 15 segundos para estabilização

3. **Deploy da Aplicação**
   - Cria nova instância ACI com configurações:
     - **Nome**: `aci-app-nextjob-rm555197`
     - **DNS**: `aci-app-nextjob-rm555197.eastus.azurecontainer.io`
     - **CPU**: 1 core
     - **Memória**: 1.5 GB
     - **Porta**: 8080 (pública)
     - **Restart Policy**: Always

4. **Variáveis de Ambiente Injetadas**
   - `SPRING_DATASOURCE_URL` - URL do banco PostgreSQL
   - `SPRING_DATASOURCE_USERNAME` - Usuário do banco
   - `SPRING_DATASOURCE_PASSWORD` - Senha (secure variable)
   - `SPRING_JPA_HIBERNATE_DDL_AUTO=validate`
   - `SPRING_FLYWAY_ENABLED=true` - Ativa migrações
   - `GROQ_API_KEY` - Chave da API Groq
   - `GROQ_MODEL` - Modelo de IA utilizado
   - `GITHUB_CLIENT_ID` - OAuth GitHub
   - `GITHUB_CLIENT_SECRET` - OAuth Secret (secure)

5. **Health Check**
   - Aguarda 20 segundos para inicialização
   - Verifica estado do container
   - Exibe URL pública da aplicação

6. **Resultado**
   - Mostra URL completa: `http://<dns>:8080`
   - Endpoint de health: `http://<dns>:8080/actuator/health`

### 🔄 Trigger Automático

O pipeline é **disparado automaticamente** em qualquer push na branch `main`:

```yaml
trigger:
  - main
```

---


### Fluxo de Deploy Completo:

1. **Desenvolvedor** faz push do código para branch `main` no GitHub
2. **Azure Pipeline** detecta mudança e inicia automaticamente
3. **Stage Build**:
   - Compila código Java com Gradle
   - Gera JAR da aplicação
   - Constrói imagem Docker
   - Envia imagem para ACR
4. **Stage Deploy**:
   - Remove container anterior
   - Cria novo ACI com imagem atualizada
   - Configura variáveis e networking
   - Expõe aplicação com DNS público
5. **Aplicação** fica disponível instantaneamente na URL pública

---

## 🧪 Testes

```bash
# Executar todos os testes
./gradlew test

# Executar com relatório detalhado
./gradlew test --info

# Build completo (compilação + testes)
./gradlew build

# Ver relatório HTML dos testes
# Abrir: build/reports/tests/test/index.html
```

---

## 📁 Estrutura do Projeto

```
GS_Next_Job_DevOps/
├── src/
│   ├── main/
│   │   ├── java/com/example/NextJobAPI/
│   │   │   ├── NextJobApiApplication.java       # Classe principal
│   │   │   ├── auth/                           # Autenticação e listeners
│   │   │   ├── config/                         # Configurações do Spring
│   │   │   │   ├── SecurityConfiguration.java  # Spring Security
│   │   │   │   ├── OAuth2Configuration.java    # OAuth2 GitHub
│   │   │   │   ├── CacheConfiguration.java     # Cache
│   │   │   │   └── InternationalizationConfig  # i18n
│   │   │   ├── controller/                     # REST Controllers
│   │   │   ├── service/                        # Lógica de negócio
│   │   │   ├── repository/                     # Spring Data JPA
│   │   │   ├── model/                          # Entidades JPA
│   │   │   ├── dto/                            # DTOs
│   │   │   └── exception/                      # Exceções customizadas
│   │   └── resources/
│   │       ├── application.properties          # Config principal
│   │       ├── application-dev.properties      # Config dev
│   │       ├── messages_pt_BR.properties       # i18n Português
│   │       ├── messages_en_US.properties       # i18n Inglês
│   │       ├── db/migration/                   # Scripts Flyway
│   │       │   ├── V1__create_usuario_table.sql
│   │       │   ├── V2__create_curriculo_table.sql
│   │       │   └── ...
│   │       └── templates/                      # Templates Thymeleaf
│   └── test/                                    # Testes unitários
│
├── build.gradle                                 # Configuração Gradle
├── settings.gradle                              # Settings do projeto
├── gradlew                                      # Gradle Wrapper (Unix)
├── gradlew.bat                                  # Gradle Wrapper (Windows)
│
├── Dockerfile                                   # Multi-stage build
├── docker-compose.yml                           # PostgreSQL local
│
├── azure-pipelines.yml                          # Pipeline CI/CD
├── setup.sh                                     # ✅ Criar infraestrutura
├── delete.sh                                    # ✅ Remover infraestrutura
│
└── README.md                                    # Este arquivo
```

---

## 🔐 Segurança

O projeto implementa múltiplas camadas de segurança:

- ✅ **Spring Security** configurado com autenticação robusta
- ✅ **OAuth2** integrado (login social com GitHub)
- ✅ **BCrypt** para hash de senhas
- ✅ **HTTPS** recomendado em produção
- ✅ **Environment Variables** para credenciais sensíveis
- ✅ **Container não-root** no Dockerfile
- ✅ **Health checks** automáticos
- ✅ **Restart policy** configurado para alta disponibilidade

---

## 🌍 Internacionalização (i18n)

O sistema suporta múltiplos idiomas:

- 🇧🇷 **Português (Brasil)** - `messages_pt_BR.properties`
- 🇺🇸 **Inglês (EUA)** - `messages_en_US.properties`

Para adicionar um novo idioma:
1. Crie arquivo `messages_{codigo}.properties` em `src/main/resources/`
2. Adicione as traduções das chaves existentes
3. Configure no `InternationalizationConfiguration.java` se necessário

---

## 📚 Recursos e Documentação

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances/)
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry/)
- [Groq API Documentation](https://console.groq.com/docs)
- [Flyway Migrations](https://flywaydb.org/documentation/)
- [Docker Documentation](https://docs.docker.com/)
- [Gradle Build Tool](https://docs.gradle.org/)

---

## 📄 Licença

Este projeto foi desenvolvido como parte da **Global Solution** da **FIAP** - Faculdade de Informática e Administração Paulista.

**Finalidade:** Projeto acadêmico - Disciplina de DevOps

---
