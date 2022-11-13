
$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"
$location="westeurope"

$webApiSubnet="webApiSubnet"
$webFrontSubnet="webFrontSubnet"

az group create `
  --name $resourceGroup `
  --location $location

# Create a virtual network with a webFrontSubnet subnet and a webApiSubnet and a AzureBastionSubnet.
  az network vnet create `
  --name $virtualNetworkName `
  --resource-group $resourceGroup `
  --address-prefix 10.0.0.0/16 
 
# Create webFrontSubnet subnet
  az network vnet subnet create `
  --vnet-name $virtualNetworkName `
  --resource-group $resourceGroup `
  --name $webFrontSubnet `
  --address-prefix 10.0.1.0/24 

# Create webApiSubnet subnet
  az network vnet subnet create `
  --vnet-name $virtualNetworkName `
  --resource-group $resourceGroup `
  --name $webApiSubnet `
  --address-prefix 10.0.2.0/24 
  






# az network vnet peering create -g $resourceGroup -n MyVnet1ToMyVnet2 --vnet-name $virtualNetworkName  --remote-vnet "management-vnet" --allow-vnet-access