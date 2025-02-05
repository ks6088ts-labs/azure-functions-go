#!/bin/sh

set -eux

# Variables
LOCATION=eastus
RANDOM_SUFFIX=$(openssl rand -hex 4)
RESOURCE_GROUP_NAME="rg-adhoc-azure-functions-go-$RANDOM_SUFFIX"
STORAGE_NAME=stadhoc"$RANDOM_SUFFIX"
FUNCTION_APP_NAME=adhoc-azure-functions-go-"$RANDOM_SUFFIX"

# Create a resource group
az group create \
    --name "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION"

# Create a storage account
az storage account create \
    --name "$STORAGE_NAME" \
    --location "$LOCATION" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --sku Standard_LRS \
    --allow-blob-public-access false

# Create a function app
az functionapp create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$FUNCTION_APP_NAME" \
    --storage-account "$STORAGE_NAME" \
    --consumption-plan-location "$LOCATION" \
    --functions-version 4 \
    --os-type Linux \
    --runtime custom

echo "RANDOM_SUFFIX=$RANDOM_SUFFIX, FUNCTION_APP_NAME=$FUNCTION_APP_NAME"
