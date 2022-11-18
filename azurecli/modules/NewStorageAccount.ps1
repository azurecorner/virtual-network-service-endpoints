Function NewStorageAccount
{
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$storageAccountName,
      [parameter(Mandatory=$true)]
      [string]$fileShareName
     
    )
  
# Create an Azure storage account
az storage account create `
  --name $storageAccountName `
  --resource-group $resourceGroupName `
  --sku Standard_LRS `
  --kind StorageV2

# retrieve the connection string for the storage account into a variable 
$connectionString=$(az storage account show-connection-string `
  --name $storageAccountName `
  --resource-group $resourceGroupName `
  --query 'connectionString' `
  --out tsv)

  Write-Host $connectionString

# Create a file share in the storage account

az storage share create `
  --name $fileShareName `
  --quota 2048 `
  --connection-string $connectionString 
  Return $connectionString 
}