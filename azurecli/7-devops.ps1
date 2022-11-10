$resourceGroup = "virtual-network-service-endpoints-management"
$virtualNetworkName="management-vnet"


 az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "toolingServer"  `
  --vnet-name $virtualNetworkName `
  --subnet "DevOpsSubnet"  `
  --public-ip-address 'toolingServerIP' `
  --public-ip-sku Standard  `
  --admin-username 'toolingsuperuser' --admin-password 'Password123!'