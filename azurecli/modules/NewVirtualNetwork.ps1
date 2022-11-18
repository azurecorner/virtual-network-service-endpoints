Function NewVirtualNetwork
{
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$virtualNetworkName,
      [parameter(Mandatory=$true)]
      [string]$addressPrefix,
      [parameter(Mandatory=$true)]
      [Object]$subnets
    )
  
    $subnets = $subnets | ConvertFrom-Json

    # Create a virtual network with a webFrontSubnet subnet and a webApiSubnet and a AzureBastionSubnet.
    az network vnet create `
    --name $virtualNetworkName `
    --resource-group $resourceGroupName `
    --address-prefix $addressPrefix 
   # Create  subnet
    foreach ($item in $subnets) {
      az network vnet subnet create `
      --vnet-name $virtualNetworkName `
      --resource-group $resourceGroupName `
      --name $item.name `
      --address-prefix $item.addressPrefix 
    }

  $vnet =  $(az network vnet show --resource-group $resourceGroupName --name $virtualNetworkName) | ConvertFrom-Json
  Return $vnet
 
}