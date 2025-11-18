#!/bin/bash

RG_NAME="rg-nextjob"

echo "=== Deletando Resource Group: $RG_NAME ==="
az group delete --name $RG_NAME --yes

echo ""
echo "✅ Resource Group excluído com sucesso!"