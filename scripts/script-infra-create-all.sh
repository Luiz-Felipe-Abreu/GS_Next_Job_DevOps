#!/bin/bash
# ==============================================================================
# Script COMPLETO de Criação da Infraestrutura NextJob no Azure
# ==============================================================================
# RM: 555197
# Descrição: Cria TODOS os recursos necessários no Azure
#   - Resource Group
#   - Azure Container Registry (ACR)
#   - Azure Container Instance - PostgreSQL Database
#   - Azure Container Instance - Spring Boot Application
# ==============================================================================

set -e  # Para em caso de erro

# ==============================================================================
# CONFIGURAÇÕES - Altere conforme necessário
# ==============================================================================
RM="555197"
RESOURCE_GROUP="rg-nextjob-rm${RM}"
LOCATION="eastus"
ACR_NAME="acrnextjobrm${RM}"
IMAGE_NAME="appnextjob"
IMAGE_TAG="latest"

# Containers
DB_CONTAINER_NAME="aci-db-nextjob-rm${RM}"
DB_DNS_LABEL="aci-db-nextjob-rm${RM}"
APP_CONTAINER_NAME="aci-app-nextjob-rm${RM}"
APP_DNS_LABEL="aci-app-nextjob-rm${RM}"

# Banco de Dados (⚠️ ALTERE AS SENHAS EM PRODUÇÃO!)
POSTGRES_DB="nextjob"
POSTGRES_USER="nextjob"
POSTGRES_PASSWORD="${DB_PASSWORD:-nextjob}"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     🚀 CRIAÇÃO COMPLETA DA INFRAESTRUTURA NEXTJOB 🚀          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Configurações:"
echo "   RM: $RM"
echo "   Resource Group: $RESOURCE_GROUP"
echo "   Location: $LOCATION"
echo "   ACR: $ACR_NAME"
echo ""
read -p "❓ Deseja continuar? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operação cancelada pelo usuário"
    exit 1
fi

# ==============================================================================
# STEP 1: Criar Resource Group
# ==============================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 STEP 1/4: Criando Resource Group..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if az group exists --name $RESOURCE_GROUP | grep -q "true"; then
    echo "⚠️  Resource Group '$RESOURCE_GROUP' já existe! Usando existente..."
else
    echo "🔧 Criando Resource Group..."
    az group create \
        --name $RESOURCE_GROUP \
        --location $LOCATION \
        --tags "projeto=NextJob" "rm=$RM" "ambiente=producao"
    echo "✅ Resource Group criado!"
fi

# ==============================================================================
# STEP 2: Criar Azure Container Registry (ACR)
# ==============================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐳 STEP 2/4: Criando Azure Container Registry..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ACR_EXISTS=$(az acr list --resource-group $RESOURCE_GROUP --query "[?name=='$ACR_NAME'].name" -o tsv)

if [ -n "$ACR_EXISTS" ]; then
    echo "⚠️  ACR '$ACR_NAME' já existe! Atualizando..."
else
    echo "🔧 Criando ACR..."
    az acr create \
        --resource-group $RESOURCE_GROUP \
        --name $ACR_NAME \
        --sku Basic \
        --location $LOCATION \
        --admin-enabled true
    echo "✅ ACR criado!"
fi

# Habilitar admin user
az acr update --name $ACR_NAME --admin-enabled true

# Obter credenciais
ACR_USERNAME=$(az acr credential show -n $ACR_NAME --query username -o tsv)
ACR_PASSWORD=$(az acr credential show -n $ACR_NAME --query 'passwords[0].value' -o tsv)

echo "✅ ACR configurado: $ACR_NAME.azurecr.io"

# ==============================================================================
# STEP 3: Criar PostgreSQL Container (Database)
# ==============================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐘 STEP 3/4: Criando PostgreSQL Database Container..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Remover container anterior se existir
echo "🧹 Limpando container anterior (se existir)..."
az container delete \
    --resource-group $RESOURCE_GROUP \
    --name $DB_CONTAINER_NAME \
    --yes 2>/dev/null || true

sleep 5

echo "🚀 Criando container PostgreSQL..."
az container create \
    --resource-group $RESOURCE_GROUP \
    --name $DB_CONTAINER_NAME \
    --image postgres:17-alpine \
    --cpu 1 \
    --memory 1.5 \
    --environment-variables \
        POSTGRES_DB=$POSTGRES_DB \
        POSTGRES_USER=$POSTGRES_USER \
        POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    --ports 5432 \
    --dns-name-label $DB_DNS_LABEL \
    --location $LOCATION \
    --os-type Linux \
    --restart-policy Always

echo "⏳ Aguardando inicialização do PostgreSQL..."
sleep 30

DB_FQDN=$(az container show \
    --resource-group $RESOURCE_GROUP \
    --name $DB_CONTAINER_NAME \
    --query ipAddress.fqdn \
    -o tsv)

echo "✅ PostgreSQL criado: $DB_FQDN:5432"

# ==============================================================================
# STEP 4: Criar Application Container (Spring Boot)
# ==============================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "☕ STEP 4/4: Criando Application Container..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  Nota: A aplicação será criada quando a pipeline fizer o deploy"
echo "   da imagem Docker no ACR. Execute a pipeline no Azure DevOps!"
echo ""
echo "   Para deploy manual, primeiro faça:"
echo "   1. Build da imagem: docker build -t $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG ."
echo "   2. Login no ACR: az acr login --name $ACR_NAME"
echo "   3. Push da imagem: docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG"
echo "   4. Execute: script-infra-deploy-app.sh"

# ==============================================================================
# RESUMO FINAL
# ==============================================================================
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          ✅ INFRAESTRUTURA CRIADA COM SUCESSO! ✅              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 RECURSOS CRIADOS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Resource Group: $RESOURCE_GROUP"
echo "🐳 ACR: $ACR_NAME.azurecr.io"
echo "🐘 Database: $DB_FQDN:5432"
echo ""
echo "🔐 CREDENCIAIS (salve em local seguro!):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "ACR Username: $ACR_USERNAME"
echo "ACR Password: $ACR_PASSWORD"
echo ""
echo "DB Connection String:"
echo "jdbc:postgresql://$DB_FQDN:5432/$POSTGRES_DB"
echo "DB User: $POSTGRES_USER"
echo "DB Password: $POSTGRES_PASSWORD"
echo ""
echo "📝 PRÓXIMOS PASSOS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Configure as variáveis secretas no Azure DevOps Library:"
echo "   - DB_PASSWORD=$POSTGRES_PASSWORD"
echo "   - SPRING_DATASOURCE_URL=jdbc:postgresql://$DB_FQDN:5432/$POSTGRES_DB"
echo ""
echo "2. Configure a Service Connection no Azure DevOps:"
echo "   - Tipo: Docker Registry"
echo "   - Registry: $ACR_NAME.azurecr.io"
echo "   - Username: $ACR_USERNAME"
echo "   - Password: $ACR_PASSWORD"
echo ""
echo "3. Execute a Pipeline no Azure DevOps para fazer o deploy!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
