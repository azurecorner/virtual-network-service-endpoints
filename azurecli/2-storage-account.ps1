$storageAcctName="logcorner07092022"

# Create an Azure storage account
az storage account create `
  --name $storageAcctName `
  --resource-group myResourceGroup `
  --sku Standard_LRS `
  --kind StorageV2

# retrieve the connection string for the storage account into a variable 
$saConnectionString=$(az storage account show-connection-string `
  --name $storageAcctName `
  --resource-group myResourceGroup `
  --query 'connectionString' `
  --out tsv)

  Write-Host $saConnectionString

# Create a file share in the storage account

az storage share create `
  --name my-file-share `
  --quota 2048 `
  --connection-string $saConnectionString 

# Deny all network access to a storage account
az storage account update `
  --name $storageAcctName `
  --resource-group myResourceGroup `
  --default-action Deny

# Enable network access from a subnet (Private)
az storage account network-rule add `
  --resource-group myResourceGroup `
  --account-name $storageAcctName `
  --vnet-name myVirtualNetwork `
  --subnet Private