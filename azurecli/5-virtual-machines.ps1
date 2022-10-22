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


  # Create  AzureBastionSubnet
  az network vnet subnet create `
  --vnet-name $virtualNetworkName `
  --resource-group $resourceGroup `
  --name "AzureBastionSubnet" `
  --address-prefix 10.0.3.0/26 

  # Create a public IP address for Azure Bastion. The public IP is the public IP address the Bastion resource on which RDP/SSH will be accessed (over port 443). The public IP address must be in the same region as the Bastion resource you're creating.
  $publicPip='AzureBastionPip'
  $sku ='Standard'
  az network public-ip create --resource-group $resourceGroup --name $publicPip --sku  $sku 

# Create a new Azure Bastion resource in the AzureBastionSubnet of your virtual network
 $AzureBastionName='AzureBastionLogCorner'
  az network bastion create --name $AzureBastionName --public-ip-address $publicPip --resource-group $resourceGroup --vnet-name $virtualNetworkName 