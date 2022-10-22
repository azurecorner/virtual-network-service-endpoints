$resourceGroup = "virtual-network-service-endpoints"
$vnetName ="logcorner-vnet"
$location = "westeurope"
#create ressource group
New-AzResourceGroup -Name $resourceGroup -Location $location
$vnet = @{
    Name = $vnetName
    ResourceGroupName = $resourceGroup
    Location = $location 
    AddressPrefix = '10.3.0.0/16'    
}
$virtualNetwork = New-AzVirtualNetwork @vnet

# Add-AzVirtualNetworkSubnetConfig -Name "DatabaseSubnet" -VirtualNetwork $virtualNetwork -AddressPrefix "10.3.1.0/24"
# Add-AzVirtualNetworkSubnetConfig -Name "WebApiSubnet" -VirtualNetwork $virtualNetwork -AddressPrefix "10.3.2.0/24" -ServiceEndpoint =""
# $virtualNetwork | Set-AzVirtualNetwork

az network vnet subnet create -g $resourceGroup --vnet-name $vnetName -n "DatabaseSubnet"  --address-prefixes "10.3.1.0/24" 
az network vnet subnet create -g $resourceGroup --vnet-name $vnetName -n "WebApiSubnet"  --address-prefixes "10.3.2.0/24" 

#assign the Microsoft.Storage endpoint to the subnet
az network vnet subnet update `
 --vnet-name $vnetName `
 --resource-group $resourceGroup `
 --name "DatabaseSubnet" `
 --service-endpoints Microsoft.Storage

 #deny storage account network access
 $storageAcctName = "logcorner97377"
 az storage account update `
  --name $storageAcctName `
  --resource-group $resourceGroup `
  --default-action Deny

#only traffic from the Databases subnet to be able to access the storage.
az storage account network-rule add `
 --resource-group $resourceGroup `
 --account-name $storageAcctName  `
 --vnet-name $vnetName `
 --subnet "DatabaseSubnet"