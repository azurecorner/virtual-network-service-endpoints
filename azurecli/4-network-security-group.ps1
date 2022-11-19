$resourceGroup = "virtual-network-service-endpoints"
$virtualNetworkName="logcorner-vnet"
$webApiSubnetNSG="webApiSubnetNSG"
$webFrontSubnetNSG="webFrontSubnetNSG"

$webApiSubnet="webApiSubnet"
$webFrontSubnet="webFrontSubnet"

# Create a network security group  for database subnet
az network nsg create `
  --resource-group $resourceGroup `
  --name $webApiSubnetNSG

# Associate the network security group to the Private subnet  (database subnet)
az network vnet subnet update `
  --vnet-name $virtualNetworkName `
  --name $webApiSubnet `
  --resource-group $resourceGroup `
  --network-security-group $webApiSubnetNSG

# rule that follows allows outbound access to the public IP addresses assigned to the Azure Storage service:

az network nsg rule create `
  --resource-group $resourceGroup `
  --nsg-name $webApiSubnetNSG `
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
  --nsg-name $webApiSubnetNSG `
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
--name $webFrontSubnetNSG

# Associate the network security group to the public subnet

az network vnet subnet update `
  --vnet-name $virtualNetworkName `
  --name $webFrontSubnet `
  --resource-group $resourceGroup `
  --network-security-group $webFrontSubnetNSG

  # Allow access to web api

  az network nsg rule create `
  --resource-group $resourceGroup `
  --nsg-name $webFrontSubnetNSG `
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