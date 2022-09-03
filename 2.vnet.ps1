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

Add-AzVirtualNetworkSubnetConfig -Name "DatabaseSubnet" -VirtualNetwork $virtualNetwork -AddressPrefix "10.3.1.0/24"
Add-AzVirtualNetworkSubnetConfig -Name "WebApiSubnet" -VirtualNetwork $virtualNetwork -AddressPrefix "10.3.2.0/24"
$virtualNetwork | Set-AzVirtualNetwork

