# Create a virtual network
az group create `
  --name myResourceGroup `
  --location eastus

# Create a virtual network with one subnet with az network vnet create.
  az network vnet create `
  --name myVirtualNetwork `
  --resource-group myResourceGroup `
  --address-prefix 10.0.0.0/16 
 
# Create subnets
  az network vnet subnet create `
  --vnet-name myVirtualNetwork `
  --resource-group myResourceGroup `
  --name Public `
  --address-prefix 10.0.1.0/24 `


  az network vnet subnet create `
  --vnet-name myVirtualNetwork `
  --resource-group myResourceGroup `
  --name Private `
  --address-prefix 10.0.2.0/24 `
  

# assign the Microsoft.Storage endpoint to the subnet
az network vnet subnet update `
--vnet-name myVirtualNetwork `
--resource-group myResourceGroup `
--name "Private" `
--service-endpoints Microsoft.Storage

# Create a network security group
az network nsg create `
  --resource-group myResourceGroup `
  --name myNsgPrivate

# Associate the network security group to the Private subnet
az network vnet subnet update `
  --vnet-name myVirtualNetwork `
  --name Private `
  --resource-group myResourceGroup `
  --network-security-group myNsgPrivate

# rule that follows allows outbound access to the public IP addresses assigned to the Azure Storage service:

az network nsg rule create `
  --resource-group myResourceGroup `
  --nsg-name myNsgPrivate `
  --name Allow-Storage-All `
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
  --resource-group myResourceGroup `
  --nsg-name myNsgPrivate `
  --name Deny-Internet-All `
  --access Deny `
  --protocol "*" `
  --direction Outbound `
  --priority 110 `
  --source-address-prefix "VirtualNetwork" `
  --source-port-range "*" `
  --destination-address-prefix "Internet" `
  --destination-port-range "*"


  az network nsg rule create `
  --resource-group myResourceGroup `
  --nsg-name myNsgPrivate `
  --name Allow-RDP-All `
  --access Allow `
  --protocol Tcp `
  --direction Inbound `
  --priority 120 `
  --source-address-prefix "*" `
  --source-port-range "*" `
  --destination-address-prefix "VirtualNetwork" `
  --destination-port-range "3389 "