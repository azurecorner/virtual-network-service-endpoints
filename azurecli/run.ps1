# ./1-storage-account.ps1
# ./2-virtual-network.ps1
# ./3-virtual-machines.ps1
# ./4-network-security-group.ps1
# ./5-service-endpoint.ps1
# ./6-management.ps1

$resourceGroupName = "virtual-network-service-endpoints"
$storageAccountName="logcorn7634733"
$fileShareName="blog-file-share"
$location="westeurope"
az group create `
  --name $resourceGroupName `
  --location $location

  $curDir = Get-Location
Write-Host "Current Working Directory: $curDir"

Get-ChildItem -Path "$curDir/modules" -Include *.ps1  | Import-Module
  # Import-Module "C:\Users\tocan\source\repos\CYBER SECURITY\virtual-network-service-endpoints\azurecli\1-storage-account.ps1"
# Create storage account
$ConnectionString = NewStorageAccount -resourceGroupName $resourceGroupName -storageAccountName $storageAccountName -fileShareName $fileShareName
Write-Host $ConnectionString