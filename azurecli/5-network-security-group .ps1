$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"
$databaseNetworkSecurityGroupName="DatabaseSubnetNSG"
$webApiNetworkSecurityGroupName="WebApiSubnetNSG"

$DatabaseSubnet="DatabaseSubnet"
$WebApiSubnet="WebApiSubnet"

# Create a network security group  for database subnet
az network nsg create `
  --resource-group $resourceGroup `
  --name $databaseNetworkSecurityGroupName

# Associate the network security group to the Private subnet  (database subnet)
az network vnet subnet update `
  --vnet-name $virtualNetworkName `
  --name $DatabaseSubnet `
  --resource-group $resourceGroup `
  --network-security-group $databaseNetworkSecurityGroupName

# rule that follows allows outbound access to the public IP addresses assigned to the Azure Storage service:

az network nsg rule create `
  --resource-group $resourceGroup `
  --nsg-name $databaseNetworkSecurityGroupName `
  --name "Allow-Storage-All" `
  --access Allow `
  --protocol "*" `
  --direction Outbound `
  --priority 100 `
  --source-address-prefix "VirtualNetwork" `
  --source-port-range "*" `
  --destination-address-prefix "Storage" `
  --destination-port-range "*" `
  --description "Allow access to Azure Storage"

# Create another outbound security rule that denies communication to the internet

az network nsg rule create `
  --resource-group $resourceGroup `
  --nsg-name $databaseNetworkSecurityGroupName `
  --name "Deny-Internet-All" `
  --access Deny `
  --protocol "*" `
  --direction Outbound `
  --priority 110 `
  --source-address-prefix "VirtualNetwork" `
  --source-port-range "*" `
  --destination-address-prefix "Internet" `
  --destination-port-range "*"  `
  --description "Deny access to Internet."


  # Create a network security group for web api subnet
az network nsg create `
--resource-group $resourceGroup `
--name $webApiNetworkSecurityGroupName

# Associate the network security group to the public subnet

az network vnet subnet update `
  --vnet-name $virtualNetworkName `
  --name $WebApiSubnet `
  --resource-group $resourceGroup `
  --network-security-group $webApiNetworkSecurityGroupName

  # Allow access to web api

  az network nsg rule create `
  --resource-group $resourceGroup `
  --nsg-name $webApiNetworkSecurityGroupName `
  --name "Allow-Web-All" `
  --access Allow `
  --protocol Tcp `
  --direction Inbound `
  --priority 100 `
  --source-address-prefix "*" `
  --source-port-range "*" `
  --destination-address-prefix "VirtualNetwork" `
  --destination-port-range 80 443 `
  --description "Allow access to web api"