# Create an Azure Functions project

[Quickstart: Create a Go or Rust function in Azure using Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-other?tabs=go%2Cwindows)


```shell
mkdir -p examples/HelloWorld
cd examples/HelloWorld

# create a function
func new \
    --name HttpExample \
    --template "Http Trigger" \
    --worker-runtime custom

# build a function
cd HttpExample
go build -o ./dist/handler .

# run server locally
cd ../
func start

# curl http://localhost:7071/api/HttpExample -vvvv
```

# Create Azure resources
## with Azure CLI

```shell
randomIdentifier=$(date "+%Y%m%d%H%M%S")

resourceGroup="rg-$randomIdentifier"
storageAccount="sa$randomIdentifier"
functionApp="fa-$randomIdentifier"
skuStorage="Standard_LRS"
functionsVersion="4"
location="japaneast"
runtime="custom"
osType="windows"

# Create a resource group
echo "Creating $resourceGroup in "$location"..."
az group create --name $resourceGroup --location "$location"

# Create an Azure storage account in the resource group.
echo "Creating storage account $storageAccount"
az storage account create --name $storageAccount --location "$location" --resource-group $resourceGroup --sku $skuStorage

# Create a serverless function app in the resource group.
echo "Creating $functionApp"
az functionapp create \
    --name $functionApp \
    --storage-account $storageAccount \
    --consumption-plan-location "$location" \
    --resource-group $resourceGroup \
    --functions-version $functionsVersion \
    --os-type $osType \
    --runtime $runtime

# Delete resources
az group delete --name $resourceGroup
```

## with Bicep

Ref. [Quickstart: Create and deploy Azure Functions resources using Bicep](https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-bicep?tabs=CLI)

```shell
cd examples/HelloWorld/iac/bicep/

randomIdentifier=$(date "+%Y%m%d%H%M%S")
resourceGroup="rg-$randomIdentifier"
location="japaneast"

# create resource group
az group create --name $resourceGroup --location "$location"

# bicep
az deployment group create --resource-group $resourceGroup --template-file main.bicep --parameters prefix=azfuncgo

# delete resources
az group delete --name $resourceGroup
```

## with Terraform

```shell
cd examples/HelloWorld/iac/terraform/
terraform init

# create resources
terraform apply

# delete resources
terraform destroy
```

# Build a function

```shell
cd examples/HelloWorld/HttpExample

# The os/arch of release binary should be set with the same one as the target server
make build GOOS=windows GOARCH=amd64
```

# Deploy a function

## Manually with Azure Functions Core Tools

```shell
functionApp="azfuncgo-fa"

# Publish function app manually via Azure Functions Core Tools
cd examples/HelloWorld
func azure functionapp publish $functionApp --custom
```

## GitHub Actions

Register Azure credentials on GitHub secrets with the following commands.

Ref. [Configure deployment credentials](https://github.com/azure/login#configure-deployment-credentials)
Ref. [Quickstart: Deploy Bicep files by using GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=userlevel%2CCLI)

```shell
rgName="your resource group name"
spName="your service principal name"
subscriptionId=$(az account show -o tsv --query id)

# generate AZURE_CREDENTIALS
AZURE_CREDENTIALS=$(az ad sp create-for-rbac \
    --name $spName \
    --role contributor \
    --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
    --sdk-auth)

# set GitHub secret
gh secret set AZURE_CREDENTIALS -b $AZURE_CREDENTIALS
gh secret set SUBSCRIPTION_ID -b $subscriptionId

# See the following deployment scripts
# - .github/workflows/deploy-http-example.yml
# - .github/workflows/deploy-hello-world-bicep.yml
```
