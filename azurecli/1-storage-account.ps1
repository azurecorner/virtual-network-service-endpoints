$resourceGroup = "virtual-network-service-endpoints"
$storageAcctName="logcorner07092022"
$fileShareName="blog-file-share"
$location="westeurope"

az group create `
  --name $resourceGroup `
  --location $location
  
# Create an Azure storage account
az storage account create `
  --name $storageAcctName `
  --resource-group $resourceGroup `
  --sku Standard_LRS `
  --kind StorageV2

# retrieve the connection string for the storage account into a variable 
$saConnectionString=$(az storage account show-connection-string `
  --name $storageAcctName `
  --resource-group $resourceGroup `
  --query 'connectionString' `
  --out tsv)

  Write-Host $saConnectionString

# Create a file share in the storage account

az storage share create `
  --name $fileShareName `
  --quota 2048 `
  --connection-string $saConnectionString 

