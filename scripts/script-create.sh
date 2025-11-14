#!/bin/bash

# ============================================
# NextJob - Script Completo de Infraestrutura Azure
# Provisiona todos os recursos necessários
# ============================================

# Configurações Gerais
RESOURCE_GROUP="rg-nextjob"
LOCATION="brazilsouth"

# Configurações ACR
ACR_NAME="acrnextjob"

# Configurações Database
DB_SERVER_NAME="postgres-nextjob"
DB_NAME="nextjob"
DB_ADMIN_USER="nextjobadmin"
DB_ADMIN_PASSWORD="NextJob@2025"

# Configurações ACI
ACI_NAME="aci-nextjob"
IMAGE_NAME="nextjob"
TAG="latest"

echo "============================================"
echo "NextJob - Provisionamento Completo Azure"
echo "============================================"
echo ""

# ============================================
# 1. RESOURCE GROUP
# ============================================
echo "1. Criando Resource Group..."
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION \
    --output table

echo "✅ Resource Group criado!"
echo ""

# ============================================
# 2. AZURE CONTAINER REGISTRY (ACR)
# ============================================
echo "2. Criando Azure Container Registry..."
az acr create \
    --resource-group $RESOURCE_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true \
    --output table

echo "✅ ACR criado!"
echo ""

# Obter credenciais do ACR
echo "Obtendo credenciais do ACR..."
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv)

echo "Registry: ${ACR_NAME}.azurecr.io"
echo "Username: $ACR_USERNAME"
echo ""

# Login no ACR
echo "Fazendo login no ACR..."
az acr login --name $ACR_NAME

# Build e Push da imagem
echo "Construindo e enviando imagem Docker..."
docker build -t ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG} ..
docker push ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG}

echo "✅ Imagem Docker enviada!"
echo ""

# ============================================
# 3. AZURE DATABASE FOR POSTGRESQL
# ============================================
echo "3. Criando Azure Database for PostgreSQL..."
az postgres flexible-server create \
    --resource-group $RESOURCE_GROUP \
    --name $DB_SERVER_NAME \
    --location $LOCATION \
    --admin-user $DB_ADMIN_USER \
    --admin-password $DB_ADMIN_PASSWORD \
    --sku-name Standard_B1ms \
    --tier Burstable \
    --version 14 \
    --storage-size 32 \
    --public-access 0.0.0.0 \
    --output table

echo "✅ PostgreSQL Server criado!"
echo ""

# Criar banco de dados
echo "Criando banco de dados '$DB_NAME'..."
az postgres flexible-server db create \
    --resource-group $RESOURCE_GROUP \
    --server-name $DB_SERVER_NAME \
    --database-name $DB_NAME \
    --output table

echo "✅ Database criado!"
echo ""

# Configurar firewall
echo "Configurando regras de firewall..."
az postgres flexible-server firewall-rule create \
    --resource-group $RESOURCE_GROUP \
    --name $DB_SERVER_NAME \
    --rule-name AllowAzureServices \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0 \
    --output table

echo "✅ Firewall configurado!"
echo ""

# ============================================
# 4. AZURE CONTAINER INSTANCE (ACI)
# ============================================
echo "4. Criando Azure Container Instance..."

DB_URL="jdbc:postgresql://${DB_SERVER_NAME}.postgres.database.azure.com:5432/${DB_NAME}?sslmode=require"

az container create \
    --resource-group $RESOURCE_GROUP \
    --name $ACI_NAME \
    --image ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG} \
    --registry-login-server ${ACR_NAME}.azurecr.io \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --dns-name-label nextjob-app \
    --ports 8080 \
    --cpu 1 \
    --memory 1.5 \
    --environment-variables \
        DATABASE_URL="$DB_URL" \
        DATABASE_USERNAME="$DB_ADMIN_USER" \
        DATABASE_PASSWORD="$DB_ADMIN_PASSWORD" \
        SERVER_PORT="8080" \
        JPA_DDL_AUTO="update" \
        JPA_SHOW_SQL="false" \
        LOG_LEVEL="INFO" \
    --output table

echo "✅ Container Instance criado!"
echo ""

# Obter FQDN
FQDN=$(az container show --resource-group $RESOURCE_GROUP --name $ACI_NAME --query "ipAddress.fqdn" -o tsv)

# ============================================
# RESUMO DA INFRAESTRUTURA
# ============================================
echo ""
echo "============================================"
echo "✅ PROVISIONAMENTO CONCLUÍDO COM SUCESSO!"
echo "============================================"
echo ""
echo "📦 Resource Group: $RESOURCE_GROUP"
echo "📍 Location: $LOCATION"
echo ""
echo "🐳 Container Registry:"
echo "   - Registry: ${ACR_NAME}.azurecr.io"
echo "   - Username: $ACR_USERNAME"
echo "   - Imagem: ${IMAGE_NAME}:${TAG}"
echo ""
echo "🗄️  PostgreSQL Database:"
echo "   - Server: ${DB_SERVER_NAME}.postgres.database.azure.com"
echo "   - Database: $DB_NAME"
echo "   - Username: $DB_ADMIN_USER"
echo "   - Connection: $DB_URL"
echo ""
echo "☁️  Container Instance:"
echo "   - Nome: $ACI_NAME"
echo "   - URL: http://${FQDN}:8080"
echo ""
echo "============================================"
echo "Acesse a aplicação em: http://${FQDN}:8080"
echo "============================================"
echo ""
