#!/bin/sh

set -eux

# check if RESOURCE_GROUP and FUNCTION_APP are set
if [ -z ${RESOURCE_GROUP+x} ]; then echo "RESOURCE_GROUP is unset"; exit 1; fi
if [ -z ${FUNCTION_APP+x} ]; then echo "FUNCTION_APP is unset"; exit 1; fi

cd configs
zip -r function.zip .

az functionapp deployment source config-zip \
    --resource-group $RESOURCE_GROUP \
    --name $FUNCTION_APP \
    --src function.zip
