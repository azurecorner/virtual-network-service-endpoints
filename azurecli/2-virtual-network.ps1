
$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"
$location="westeurope"

az group create `
  --name $resourceGroup `
  --location $location

# Create a virtual network with a WebApiSubnet subnet and a DatabaseSubnet and a AzureBastionSubnet.
  az network vnet create `
  --name $virtualNetworkName `
  --resource-group $resourceGroup `
  --address-prefix 10.0.0.0/16 
 
# Create WebApiSubnet subnet
  az network vnet subnet create `
  --vnet-name $virtualNetworkName `
  --resource-group $resourceGroup `
  --name "WebApiSubnet" `
  --address-prefix 10.0.1.0/24 

# Create DatabaseSubnet subnet
  az network vnet subnet create `
  --vnet-name $virtualNetworkName `
  --resource-group $resourceGroup `
  --name "DatabaseSubnet" `
  --address-prefix 10.0.2.0/24 
  

#management

az group create `
  --name "virtual-network-service-endpoints-management" `
  --location $location
# 
az network vnet create `
--name "management-vnet" `
--resource-group "virtual-network-service-endpoints-management" `
--address-prefix 10.1.0.0/16 

# Create WebApiSubnet subnet
az network vnet subnet create `
--vnet-name "management-vnet" `
--resource-group "virtual-network-service-endpoints-management" `
--name "AzureBastionSubnet" `
--address-prefix 10.1.1.0/26 

# Create DatabaseSubnet subnet
az network vnet subnet create `
--vnet-name "management-vnet" `
--resource-group "virtual-network-service-endpoints-management" `
--name "DevOpsSubnet" `
--address-prefix 10.1.2.0/24 




# az network vnet peering create -g $resourceGroup -n MyVnet1ToMyVnet2 --vnet-name $virtualNetworkName  --remote-vnet "management-vnet" --allow-vnet-access