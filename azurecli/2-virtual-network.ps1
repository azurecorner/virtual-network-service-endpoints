
$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"

# Create a virtual network with a WebApiSubnet subnet and a DatabaseSubnet.
  az network vnet create `
  --name $virtualNetworkName `
  --resource-group $resourceGroup `
  --address-prefix 10.0.0.0/16 
 
# Create subnets
  az network vnet subnet create `
  --vnet-name $virtualNetworkName `
  --resource-group $resourceGroup `
  --name "WebApiSubnet" `
  --address-prefix 10.0.1.0/24 


  az network vnet subnet create `
  --vnet-name $virtualNetworkName `
  --resource-group $resourceGroup `
  --name "DatabaseSubnet" `
  --address-prefix 10.0.2.0/24 
  
