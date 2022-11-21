Function NewBastionHost
{
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$virtualNetworkName,
      [parameter(Mandatory=$true)]
      [string]$publicIpName,
      [parameter(Mandatory=$true)]
      [string]$publicIpSku,
      [parameter(Mandatory=$true)]
      [string]$AzureBastionName
    )
    
    
# Create a public IP address for Azure Bastion. The public IP is the public IP address the Bastion resource on which RDP/SSH will be accessed (over port 443). The public IP address must be in the same region as the Bastion resource you're creating.

  az network public-ip create --resource-group $resourceGroupName  `
                              --name $publicIpName --sku  $publicIpSku 

# Create a new Azure Bastion resource in the AzureBastionSubnet of your virtual network
  az network bastion create --name $AzureBastionName  `
                            --public-ip-address $publicIpName  `
                            --resource-group $resourceGroupName  `
                            --vnet-name $virtualNetworkName 
    
}
 