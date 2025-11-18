#!/bin/bash

# Variáveis
ACR_NAME="acrnextjob"
RG_NAME="rg-nextjob"
IMAGE_NAME="appnextjob:latest"
LOCATION="eastus"
RM="555197"
DB_NAME="nextjob"
DB_USER="nextjob"
DB_PASSWORD="nextjob"

echo "=== Criando Resource Group ==="
az group create --name $RG_NAME --location $LOCATION

echo "=== Criando Azure Container Registry ==="
az acr create --resource-group $RG_NAME --name $ACR_NAME --sku Basic --location $LOCATION

echo "=== Habilitando admin user no ACR ==="
az acr update --name $ACR_NAME --admin-enabled true

# Aguardar a propagação das configurações
echo "Aguardando propagação das configurações do ACR..."
sleep 10

# 🔐 Fazer login no ACR
echo "=== Fazendo login no ACR ==="
az acr login --name $ACR_NAME

# ⬇️⬆️ Importar imagem base do Postgres
echo "=== Importando imagem postgres:17-alpine para o ACR ==="

# Pull da imagem especificando a plataforma AMD64 (arquitetura do ACI)
echo "Baixando imagem postgres:17-alpine para AMD64..."
docker pull --platform linux/amd64 postgres:17-alpine

# Tag da imagem para o ACR
echo "Taggeando imagem para o ACR..."
docker tag postgres:17-alpine $ACR_NAME.azurecr.io/postgres:17-alpine

# Push da imagem para o ACR
echo "Enviando imagem para o ACR..."
docker push $ACR_NAME.azurecr.io/postgres:17-alpine

echo "✅ Imagem postgres importada com sucesso!"

# Verificar se a imagem está no ACR
echo "=== Verificando imagem no ACR ==="
az acr repository show --name $ACR_NAME --repository postgres

# 🔐 Criar Service Principal para ACI acessar ACR
echo "=== Configurando permissões do ACR ==="

# Obter o ID do ACR
ACR_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Criar Service Principal com permissão de pull no ACR
SP_NAME="sp-aci-${ACR_NAME}"
echo "Criando Service Principal: $SP_NAME"

# Deletar SP anterior se existir
az ad sp delete --id "http://${SP_NAME}" 2>/dev/null || true

# Criar novo Service Principal
SP_PASSWD=$(az ad sp create-for-rbac \
  --name "http://${SP_NAME}" \
  --scopes $ACR_ID \
  --role acrpull \
  --query password \
  --output tsv)

# Obter o App ID do Service Principal
SP_APP_ID=$(az ad sp list --display-name "http://${SP_NAME}" --query [0].appId --output tsv)

echo "✅ Service Principal criado com sucesso!"
echo "   App ID: $SP_APP_ID"

# Aguardar propagação das permissões
echo "Aguardando propagação das permissões..."
sleep 15

# 🗄️ Criar container do banco de dados
echo "=== Criando container do banco de dados PostgreSQL ==="

ACR_LOGIN_SERVER="${ACR_NAME}.azurecr.io"

# Nomes do container e DNS do banco
DB_CONTAINER_NAME="aci-db-nextjob-rm${RM}"
DB_DNS_LABEL="aci-db-nextjob-rm${RM}"

# Excluir container anterior se existir
echo "Limpando container anterior do banco (se existir)..."
az container delete --resource-group "$RG_NAME" --name "$DB_CONTAINER_NAME" --yes 2>/dev/null || true
sleep 5

# Criar container do banco usando Service Principal
echo "Criando container do banco: $DB_CONTAINER_NAME"
az container create \
  --resource-group "$RG_NAME" \
  --name "$DB_CONTAINER_NAME" \
  --image "${ACR_LOGIN_SERVER}/postgres:17-alpine" \
  --cpu 1 --memory 2 \
  --registry-login-server "$ACR_LOGIN_SERVER" \
  --registry-username "$SP_APP_ID" \
  --registry-password "$SP_PASSWD" \
  --environment-variables \
    POSTGRES_PASSWORD="$DB_PASSWORD" \
    POSTGRES_DB="$DB_NAME" \
    POSTGRES_USER="$DB_USER" \
  --ports 5432 \
  --os-type Linux \
  --dns-name-label "$DB_DNS_LABEL" \
  --location "$LOCATION" \
  --restart-policy Always

# Verificar se o container foi criado
if [ $? -eq 0 ]; then
    echo "✅ Container criado com sucesso!"
    
    # Aguardar o container inicializar
    echo "Aguardando container inicializar..."
    sleep 10
    
    # Obter FQDN do banco
    DB_FQDN=$(az container show --resource-group "$RG_NAME" --name "$DB_CONTAINER_NAME" --query ipAddress.fqdn -o tsv)
    
    echo "✅ Banco de dados criado com sucesso!"
    echo "📊 FQDN do banco: $DB_FQDN"
    echo "📊 Porta: 5432"
    echo "📊 Database: $DB_NAME"
    echo "📊 User: $DB_USER"
    echo ""
    echo "🔑 Credenciais do Service Principal (guarde para uso futuro):"
    echo "   App ID: $SP_APP_ID"
    echo "   Password: $SP_PASSWD"
else
    echo "❌ Erro ao criar container do banco de dados"
    exit 1
fi