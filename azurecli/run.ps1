############  VARIABLES ######################
$resourceGroupName = "virtual-network-service-endpoints"
$storageAccountName="logcorn7634733"
$fileShareName="blog-file-share"
$location="westeurope"


############  IMPORT MODULES ######################
$curDir = Get-Location
Write-Host "Current Working Directory: $curDir"

Import-Module "$($curDir)\modules\NewStorageAccount.ps1"
Import-Module "$($curDir)\modules\NewVirtualNetwork.ps1"
Import-Module "$($curDir)\modules\NewVirtualMachine.ps1"
Import-Module "$($curDir)\modules\NewNetworkSecurityGroup.ps1"
Import-Module "$($curDir)\modules\NewKeyVault.ps1"
#

az group create `
  --name $resourceGroupName `
  --location $location


##############################


##################################


<# Get-ChildItem -Path "$curDir/modules" -Include *.ps1  | Import-Module #>
  
# Create storage account
 $ConnectionString = NewStorageAccount -resourceGroupName $resourceGroupName -storageAccountName $storageAccountName -fileShareName $fileShareName
 Write-Host "ConnectionString = $($ConnectionString)" -ForegroundColor Green
 
 
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
 $logcornerVnet = NewVirtualNetwork -resourceGroupName $resourceGroupName `
                  -virtualNetworkName $virtualNetworkName `
                  -addressPrefix $addressPrefix `
                  -subnets $subnets 
                
Write-Host "logcornerVnetId = $($logcornerVnet)" -ForegroundColor Green 

# CREATE VIRTUAL MACHINE  WEB API 

$subnetName="webApiSubnet"
$virtualMachineName ="webApiServer"
$image = "Win2019Datacenter"
$adminUsername = "webapisuperuser"
$adminPassword = "Password123!" | ConvertTo-SecureString -AsPlainText -Force
$webApiServerObjectId =  NewVirtualMachine -resourceGroupName $resourceGroupName `
                -virtualMachineName $virtualMachineName `
                -virtualNetworkName $virtualNetworkName `
                -subnetName  $subnetName `
                -image $image `
                -adminUsername $adminUsername `
                -adminPassword $adminPassword

Write-Host "webApiServerObjectId = $($webApiServerObjectId)" -ForegroundColor Green


# CREATE VIRTUAL MACHINE  WEB FRONT END 

$subnetName="webFrontSubnet"
$virtualMachineName ="webFrontServer"
$image = "Win2019Datacenter"
$adminUsername = "webfrontsuperuser"
$adminPassword = "Password123!" | ConvertTo-SecureString -AsPlainText -Force
$publicIpName = "webFrontServerIP"
$webFrontServerObjectId =  NewVirtualMachine -resourceGroupName $resourceGroupName `
                -virtualMachineName $virtualMachineName `
                -virtualNetworkName $virtualNetworkName `
                -subnetName  $subnetName `
                -image $image `
                -adminUsername $adminUsername `
                -adminPassword $adminPassword `
                -publicIpName $publicIpName

Write-Host "webFrontServerObjectId = $($webFrontServerObjectId)" -ForegroundColor Green


# ASSIGN NSG TO  VIRTUAL MACHINE  WEB API 
$webApiSubnetNSG="webApiSubnetNSG"
$webApiSubnet="webApiSubnet"


NewNetworkSecurityGroup  -resourceGroupName  $resourceGroupName `
-virtualNetworkName  $virtualNetworkName `
-subnetName $webApiSubnet `
-networkSecurityGroupName $webApiSubnetNSG 

# ASSIGN NSG TO  VIRTUAL MACHINE  WEB API 
$webFrontSubnetNSG="webFrontSubnetNSG"
$webFrontSubnet="webFrontSubnet"

$nsgRules = @"
[
  {
    "name": "Allow-Web-All",
    "access": "Allow",
    "protocol":"Tcp",
    "direction":"Inbound",
    "priority":100,
    "sourceAddressPrefix":"*",
    "sourcePortRange":"*",
    "destinationAddressPrefix":"VirtualNetwork",
    "destinationPortRange" : [
      "80",
      "443"                            
  ] ,
    "description":"Allow access to web site"

  }
]
"@

NewNetworkSecurityGroup  -resourceGroupName  $resourceGroupName `
-virtualNetworkName  $virtualNetworkName `
-subnetName $webFrontSubnet `
-networkSecurityGroupName $webFrontSubnetNSG  `
-nsgRules  $nsgRules


 # CREATE AZURE KEY VAULT
$keyVaultName ="logcornerdior"
$secrets = @"
[
  {
    "name": "ConnectionString",
    "value": "$ConnectionString"
  }
]
"@

$secretPermissions = @"
[
  {
    "objectId": "$webApiServerObjectId",
    "value": ["get" ,"list"]
  }
]
"@

NewKeyVault   -resourceGroupName  $resourceGroupName `
            -keyVaultName   $keyVaultName `
            -secrets   $secrets  `
            -secretPermissions $secretPermissions   