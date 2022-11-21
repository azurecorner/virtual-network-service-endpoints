Function NewVirtualNetworkPeering
{
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$virtualNetworkFrom,
      [parameter(Mandatory=$true)]
      [string]$virtualNetworkTo
    )
  
    az network vnet peering create -g $resourceGroupName -n MyVnet1ToMyVnet2 --vnet-name $virtualNetworkFrom   `
    --remote-vnet $virtualNetworkTo --allow-vnet-access

    az network vnet peering create -g $resourceGroupName -n MyVnet2ToMyVnet1 --vnet-name $virtualNetworkTo   `
    --remote-vnet $virtualNetworkFrom  --allow-vnet-access
}
 