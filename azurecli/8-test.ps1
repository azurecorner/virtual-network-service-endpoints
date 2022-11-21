############  VARIABLES ######################
$resourceGroupName = "management"
$virtualNetworkName ="logcornerVnet"
$publicIpName = "AzureBastionNamePip"
$publicIpSku = "Standard"
$AzureBastionName ="AzureBastionLogCorner"
############  IMPORT MODULES ######################
$curDir = Get-Location
Write-Host "Current Working Directory: $curDir"

Import-Module "$($curDir)\modules\NewStorageAccount.ps1"
Import-Module "$($curDir)\modules\NewVirtualNetwork.ps1"
Import-Module "$($curDir)\modules\NewVirtualMachine.ps1"
Import-Module "$($curDir)\modules\NewNetworkSecurityGroup.ps1"
Import-Module "$($curDir)\modules\NewKeyVault.ps1"
Import-Module "$($curDir)\modules\NewBastionHost.ps1"
#

NewBastionHost -resourceGroupName  $resourceGroupName `
               -virtualNetworkName  $virtualNetworkName  `
               -publicIpName  $publicIpName `
               -publicIpSku  $publicIpSku  `
               -AzureBastionName  $AzureBastionName
    
    
