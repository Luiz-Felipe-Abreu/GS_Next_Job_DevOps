#!/bin/bash
# ==============================================================================
# Script de DELEÇÃO COMPLETA da Infraestrutura NextJob no Azure
# ==============================================================================
# RM: 555197
# Descrição: DELETA TODOS os recursos do Azure (Resource Group e tudo dentro)
# ⚠️  ATENÇÃO: Esta operação é IRREVERSÍVEL!
# ==============================================================================

set -e  # Para em caso de erro

# ==============================================================================
# CONFIGURAÇÕES
# ==============================================================================
RM="555197"
RESOURCE_GROUP="rg-nextjob-rm${RM}"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         ⚠️  DELEÇÃO COMPLETA DA INFRAESTRUTURA ⚠️              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "🔴 ATENÇÃO: Esta operação irá DELETAR PERMANENTEMENTE:"
echo "   📦 Resource Group: $RESOURCE_GROUP"
echo "   🐳 Azure Container Registry (ACR)"
echo "   🐘 PostgreSQL Database Container"
echo "   ☕ Application Container"
echo "   📊 Todos os dados armazenados"
echo ""
echo "⚠️  ESTA OPERAÇÃO É IRREVERSÍVEL!"
echo ""
read -p "❓ Tem CERTEZA que deseja DELETAR TUDO? Digite 'DELETE' para confirmar: " CONFIRM

if [ "$CONFIRM" != "DELETE" ]; then
    echo "❌ Operação cancelada. Nada foi deletado."
    exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🗑️  Verificando se o Resource Group existe..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! az group exists --name $RESOURCE_GROUP | grep -q "true"; then
    echo "ℹ️  Resource Group '$RESOURCE_GROUP' não existe!"
    echo "✅ Nada para deletar."
    exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔥 Deletando Resource Group '$RESOURCE_GROUP'..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏳ Esta operação pode levar alguns minutos..."
echo ""

az group delete \
    --name $RESOURCE_GROUP \
    --yes \
    --no-wait

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Comando de deleção enviado com sucesso!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "ℹ️  A deleção está sendo processada em background."
echo "   Para verificar o status, execute:"
echo ""
echo "   az group list --output table | grep nextjob"
echo ""
echo "   Quando o Resource Group não aparecer mais, a deleção estará completa."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
