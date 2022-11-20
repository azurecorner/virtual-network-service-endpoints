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



# ASSIGN NSG TO  VIRTUAL MACHINE  WEB SITE 
$webFrontSubnetNSG="webFrontSubnetNSG"
$webFrontSubnet="webFrontSubnet"
$virtualNetworkName="logcorner-vnet"
$port = '80 443';
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


 