$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"
$databaseNetworkSecurityGroupName="logcorner-database-nsg"
$webApiNetworkSecurityGroupName="logcorner-webapi-nsg"

# Create a network security group
az network nsg create `
  --resource-group $resourceGroup `
  --name $databaseNetworkSecurityGroupName

# Associate the network security group to the Private subnet
az network vnet subnet update `
  --vnet-name $virtualNetworkName `
  --name "DatabaseSubnet" `
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
  --destination-port-range "*"

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
  --destination-port-range "*"




  # Create a network security group
az network nsg create `
--resource-group $resourceGroup `
--name $webApiNetworkSecurityGroupName

az network vnet subnet update `
  --vnet-name $virtualNetworkName `
  --name "WebApiSubnet" `
  --resource-group $resourceGroup `
  --network-security-group $webApiNetworkSecurityGroupName


  az network nsg rule create `
  --resource-group $resourceGroup `
  --nsg-name $webApiNetworkSecurityGroupName `
  --name "Allow-RDP-All" `
  --access Allow `
  --protocol Tcp `
  --direction Inbound `
  --priority 110 `
  --source-address-prefix "*" `
  --source-port-range "*" `
  --destination-address-prefix "VirtualNetwork" `
  --destination-port-range "3389"


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
  --destination-port-range 80 443