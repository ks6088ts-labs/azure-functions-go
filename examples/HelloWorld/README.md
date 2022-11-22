# Logs

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
make build

# run server locally
cd ../
func start

# curl http://localhost:7071/api/HttpExample -vvvv
```

# Deploy

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

# Build functions
cd examples/HelloWorld/HttpExample
make build GOOS=$osType GOARCH=amd64

# Publish function app
cd examples/HelloWorld
func azure functionapp publish $functionApp
```

# Deploy with GitHub Actions

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
```

# References

- [Quickstart: Create a Go or Rust function in Azure using Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-other?tabs=go%2Cwindows)
- [コマンドラインでAzure Functions Custom Handlerをデプロイする（Go / HTTP trigger編）](https://qiita.com/qt-luigi/items/aad12cefcd4af825a632)
- [Configure deployment credentials](https://github.com/azure/login#configure-deployment-credentials)
