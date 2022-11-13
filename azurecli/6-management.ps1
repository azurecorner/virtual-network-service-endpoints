$resourceGroup = "virtual-network-service-endpoints-management"
$virtualNetworkName="management-vnet"


#management

az group create `
  --name "virtual-network-service-endpoints-management" `
  --location $location
# 
az network vnet create `
--name "management-vnet" `
--resource-group "virtual-network-service-endpoints-management" `
--address-prefix 10.1.0.0/16 

# Create webFrontSubnet subnet
az network vnet subnet create `
--vnet-name "management-vnet" `
--resource-group "virtual-network-service-endpoints-management" `
--name "AzureBastionSubnet" `
--address-prefix 10.1.1.0/26 

# Create webApiSubnet subnet
az network vnet subnet create `
--vnet-name "management-vnet" `
--resource-group "virtual-network-service-endpoints-management" `
--name "DevOpsSubnet" `
--address-prefix 10.1.2.0/24 

 az vm create `
  --resource-group $resourceGroup `
  --image "Win2019Datacenter" `
  --name "toolingServer"  `
  --vnet-name $virtualNetworkName `
  --subnet "DevOpsSubnet"  `
  --public-ip-address 'toolingServerIP' `
  --public-ip-sku Standard  `
  --admin-username 'toolingsuperuser' --admin-password 'Password123!'


  
# Create a public IP address for Azure Bastion. The public IP is the public IP address the Bastion resource on which RDP/SSH will be accessed (over port 443). The public IP address must be in the same region as the Bastion resource you're creating.
  $publicPip='AzureBastionPip'
  $sku ='Standard'
  az network public-ip create --resource-group $resourceGroup --name $publicPip --sku  $sku 

# Create a new Azure Bastion resource in the AzureBastionSubnet of your virtual network
 $AzureBastionName='AzureBastionLogCorner'
  az network bastion create --name $AzureBastionName --public-ip-address $publicPip --resource-group $resourceGroup --vnet-name $virtualNetworkName 


