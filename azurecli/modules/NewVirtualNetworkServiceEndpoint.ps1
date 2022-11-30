Function NewVirtualNetworkServiceEndpoint
{
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$virtualNetworkName,
      [parameter(Mandatory=$true)]
      [string]$networkSecurityGroupName,
      [parameter(Mandatory=$true)]
      [string]$subnetName,
      [parameter(Mandatory=$true)]
      [string]$storageAccountName
    )
  
# assign the Microsoft.Storage endpoint to the subnet
az network vnet subnet update `
--vnet-name $virtualNetworkName `
--resource-group $resourceGroupName `
--name $subnetName `
--service-endpoints "Microsoft.Storage"

# Deny all network access to a storage account
az storage account update `
  --name $storageAccountName `
  --resource-group $resourceGroupName `
  --default-action Deny

# Enable network access from a subnet (Private)
az storage account network-rule add `
  --resource-group $resourceGroupName `
  --account-name $storageAccountName `
  --vnet-name $virtualNetworkName `
  --subnet $subnetName


<#   az network nsg rule create `
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
    --description "Allow access to Azure Storage" #>
}
 