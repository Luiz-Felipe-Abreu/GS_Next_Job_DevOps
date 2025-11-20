#!/bin/bash

# =========================
# VARIÁVEIS DE CONFIGURAÇÃO
# =========================
ACR_NAME="acrnextjob"              
RG_NAME="rg-nextjob"                    
IMAGE_NAME="appnextjob:latest"         
LOCATION="eastus"                       
RM="555197"                             
DB_NAME="nextjob"                      
DB_USER="nextjob"                       
DB_PASSWORD="nextjob"  

# ===================================
# 1. CRIAR RESOURCE GROUP
# ===================================
echo "=== Criando Resource Group ==="
az group create --name $RG_NAME --location $LOCATION

# =============================================
# 2. CRIAR AZURE CONTAINER REGISTRY (ACR)
# =============================================

echo "=== Criando Azure Container Registry ==="
az acr create --resource-group $RG_NAME --name $ACR_NAME --sku Basic --location $LOCATION

# =========================================
# 3. HABILITAR ADMIN USER NO ACR
# ==========================================
echo "=== Habilitando admin user no ACR ==="
az acr update --name $ACR_NAME --admin-enabled true

# =======================
# 4. FAZER LOGIN NO ACR
# =======================
echo "=== Fazendo login no ACR ==="
az acr login --name $ACR_NAME

# ============================================================================
# 5. IMPORTAR IMAGEM DO POSTGRESQL PARA O ACR
# ============================================================================
echo "=== Importando imagem postgres:17-alpine para o ACR ==="
docker pull postgres:17-alpine  
docker tag postgres:17-alpine $ACR_NAME.azurecr.io/postgres:17-alpine
docker push $ACR_NAME.azurecr.io/postgres:17-alpine    

echo "✅ Imagem postgres importada com sucesso!"

# ============================================================================
# 6. CRIAR CONTAINER DO BANCO DE DADOS POSTGRESQL
# ============================================================================
echo "=== Criando container do banco de dados PostgreSQL ==="

# ================================
# 6.1. OBTER CREDENCIAIS DO ACR
# ================================
# Recupera usuário e senha do ACR para autenticação
ACR_USERNAME=$(az acr credential show -n "$ACR_NAME" --query username -o tsv)
ACR_PASSWORD=$(az acr credential show -n "$ACR_NAME" --query "passwords[0].value" -o tsv)

# ======================================
# 6.2. DEFINIR NOMES DO CONTAINER E DNS
# ======================================
DB_CONTAINER_NAME="aci-db-nextjob-rm${RM}"
DB_DNS_LABEL="aci-db-nextjob-rm${RM}"

# ===========================================
# 6.3. LIMPAR CONTAINER ANTERIOR (SE EXISTIR)
# ===========================================
# Remove container antigo para evitar conflitos de DNS
echo "Limpando container anterior do banco (se existir)..."
az container delete --resource-group "$RG_NAME" --name "$DB_CONTAINER_NAME" --yes 2>/dev/null || true
sleep 5

# ============================================
# 6.4. CRIAR CONTAINER DO POSTGRESQL NO ACI
# ============================================
echo "Criando container do banco: $DB_CONTAINER_NAME"
az container create \
  --resource-group "$RG_NAME" \
  --name "$DB_CONTAINER_NAME" \
  --image "${ACR_NAME}.azurecr.io/postgres:17-alpine" \
  --cpu 1 --memory 2 \
  --registry-login-server "${ACR_NAME}.azurecr.io" \
  --registry-username "$ACR_USERNAME" \
  --registry-password "$ACR_PASSWORD" \
  --environment-variables \
    POSTGRES_PASSWORD="$DB_PASSWORD" \
    POSTGRES_DB="$DB_NAME" \
    POSTGRES_USER="$DB_USER" \
  --ports 5432 \
  --os-type Linux \
  --dns-name-label "$DB_DNS_LABEL" \
  --location "$LOCATION" \
  --restart-policy Always 

# ================================
# 6.5. OBTER URL PÚBLICA DO BANCO
# ================================
DB_FQDN=$(az container show --resource-group "$RG_NAME" --name "$DB_CONTAINER_NAME" --query ipAddress.fqdn -o tsv)

echo "✅ Banco de dados criado com sucesso! ✅"

# Teste de commit
