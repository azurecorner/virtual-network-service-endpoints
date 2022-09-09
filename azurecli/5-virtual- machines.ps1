$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"
$DatabaseSubnet="DatabaseSubnet"
$WebApiSubnet="WebApiSubnet"

# Create a VM in the Public subnet 

az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "webApiServer" `
  --vnet-name $virtualNetworkName `
  --public-ip-address "webApiServerPip" `
  --public-ip-sku Standard `
  --subnet $WebApiSubnet `
  --admin-username 'username' --admin-password 'Password123!'


# Create a VM in the private subnet (DatabaseSubnet)

az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "dataBaseServer"  `
  --vnet-name $virtualNetworkName `
  --public-ip-address "dataBaseServerPip" `
  --public-ip-sku Standard `
  --subnet $DatabaseSubnet `
  --admin-username 'username' --admin-password 'Password123!'