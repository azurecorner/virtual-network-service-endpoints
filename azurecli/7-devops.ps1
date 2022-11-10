$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"


 # Create AzureBastionSubnet subnet
 az network vnet subnet create `
 --vnet-name $virtualNetworkName `
 --resource-group $resourceGroup `
 --name "AzureDevOpsSubnet" `
 --address-prefix 10.0.4.0/26 


 az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "toolingServer"  `
  --vnet-name $virtualNetworkName `
  --subnet "AzureDevOpsSubnet"  `
  --public-ip-address 'toolingServerIP' `
  --public-ip-sku Standard  `
  --admin-username 'toolingsuperuser' --admin-password 'Password123!'