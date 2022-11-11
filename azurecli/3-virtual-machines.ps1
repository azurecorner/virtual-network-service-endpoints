$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"
$webApiSubnet="webApiSubnet"
$webFrontSubnet="webFrontSubnet"

# Create a VM in the Public subnet 

az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "webFrontServer" `
  --vnet-name $virtualNetworkName `
  --subnet $webFrontSubnet `
  --public-ip-address 'webFrontServerIP' `
  --public-ip-sku Standard  `
  --nsg '""' `
  --admin-username 'websuperuser' --admin-password 'Password123!'


# Create a VM in the private subnet (webApiSubnet)

<# az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "webApiServer"  `
  --vnet-name $virtualNetworkName `
  --subnet $webApiSubnet `
  --public-ip-address '""'`
  --nsg '""' `
  --admin-username 'dbsuperuser' --admin-password 'Password123!' #>
  az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "webApiServer"  `
  --vnet-name $virtualNetworkName `
  --subnet $webApiSubnet `
  --public-ip-address 'webApiServerIP' `
  --public-ip-sku Standard  `
  --nsg '""' `
  --admin-username 'webapisuperuser' --admin-password 'Password123!'
