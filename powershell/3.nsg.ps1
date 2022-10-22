$resourceGroup = "virtual-network-service-endpoints"
$vnetName ="logcorner-vnet"
$location = "westeurope"
$nsg="logcorner-nsg"

az network nsg create -g $resourceGroup -n $nsg 
#create an outbound rule to allow access to Storage
az network nsg rule create `
--resource-group $resourceGroup `
--nsg-name $nsg `
--name Allow_Storage `
--priority 190 `
--direction Outbound `
--source-address-prefixes "VirtualNetwork" `
--source-port-ranges '*' `
--destination-address-prefixes "Storage" `
--destination-port-ranges '*' `
--access Allow `
--protocol '*' `
--description "Allow access to Azure Storage"

#create an outbound rule to deny all internet access
az network nsg rule create `
--resource-group $resourceGroup `
--nsg-name $nsg `
--name Deny_Internet `
--priority 200 `
--direction Outbound `
--source-address-prefixes "VirtualNetwork" `
--source-port-ranges '*' `
--destination-address-prefixes "Internet" `
--destination-port-ranges '*' `
--access Deny `
--protocol '*' `
--description "Deny access to Internet."

#Associate a network security group to a subnet.
az network vnet subnet update -g $resourceGroup -n "DatabaseSubnet" --vnet-name $vnetName  --network-security-group $nsg