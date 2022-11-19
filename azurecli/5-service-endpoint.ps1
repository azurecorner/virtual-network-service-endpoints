$resourceGroup = "virtual-network-service-endpoints"
$storageAcctName="logcorner07092022"
$virtualNetworkName="logcorner-vnet"
$webApiSubnet="webApiSubnet"


# assign the Microsoft.Storage endpoint to the subnet
az network vnet subnet update `
--vnet-name $virtualNetworkName `
--resource-group $resourceGroup `
--name $webApiSubnet `
--service-endpoints "Microsoft.Storage"

# Deny all network access to a storage account
az storage account update `
  --name $storageAcctName `
  --resource-group $resourceGroup `
  --default-action Deny

# Enable network access from a subnet (Private)
az storage account network-rule add `
  --resource-group $resourceGroup `
  --account-name $storageAcctName `
  --vnet-name $virtualNetworkName `
  --subnet $webApiSubnet


  az network nsg rule create `
    --resource-group $resourceGroupName `
    --nsg-name $networkSecurityGroupName `
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

