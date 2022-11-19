############  VARIABLES ######################
$resourceGroupName = "virtual-network-service-endpoints"
$storageAccountName="logcorn7634733"
$fileShareName="blog-file-share"
$location="westeurope"


############  IMPORT MODULES ######################
Import-Module "C:\Users\tocan\source\repos\CYBER SECURITY\virtual-network-service-endpoints\azurecli\modules\NewStorageAccount.ps1"
Import-Module "C:\Users\tocan\source\repos\CYBER SECURITY\virtual-network-service-endpoints\azurecli\modules\NewVirtualNetwork.ps1"
Import-Module "C:\Users\tocan\source\repos\CYBER SECURITY\virtual-network-service-endpoints\azurecli\modules\NewVirtualMachine.ps1"

#

az group create `
  --name $resourceGroupName `
  --location $location

  $curDir = Get-Location
Write-Host "Current Working Directory: $curDir"

<# Get-ChildItem -Path "$curDir/modules" -Include *.ps1  | Import-Module #>
  
# Create storage account
 <# $ConnectionString = NewStorageAccount -resourceGroupName $resourceGroupName -storageAccountName $storageAccountName -fileShareName $fileShareName
 Write-Host "ConnectionString = $($ConnectionString)" -ForegroundColor Green
  #>
 
$virtualNetworkName="logcorner-vnet"
$addressPrefix     = "10.0.0.0/16"
$subnets = @"
[
  {
    "name": "webApiSubnet",
    "addressPrefix": "10.0.2.0/24"
  },
  {
    "name": "webFrontSubnet",
    "addressPrefix": "10.0.1.0/24"
  }
]
"@
# CREATE VIRTUAL NEtWORK 
<#  $logcornerVnet = NewVirtualNetwork -resourceGroupName $resourceGroupName `
                  -virtualNetworkName $virtualNetworkName `
                  -addressPrefix $addressPrefix `
                  -subnets $subnets 
                
Write-Host "logcornerVnetId = $($logcornerVnet)" -ForegroundColor Green  #>

# CREATE VIRTUAL MACHINE

$subnetName="webApiSubnet"
$virtualMachineName ="webApiServer"
$image = "Win2019Datacenter"
$adminUsername = "webmvcsuperuser"
$adminPassword = "Password123!" | ConvertTo-SecureString -AsPlainText -Force
$webApiServerObjectId =  NewVirtualMachine -resourceGroupName $resourceGroupName `
                -virtualMachineName $virtualMachineName `
                -virtualNetworkName $virtualNetworkName `
                -subnetName  $subnetName `
                -image $image `
                -adminUsername $adminUsername `
                -adminPassword $adminPassword

Write-Host "webApiServerObjectId = $($webApiServerObjectId)" -ForegroundColor Green