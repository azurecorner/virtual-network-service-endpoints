Function NewNetworkSecurityGroup
{
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$virtualNetworkName,
      [parameter(Mandatory=$true)]
      [string]$subnetName,
      [parameter(Mandatory=$true)]
      [string]$networkSecurityGroupName,
      [parameter(Mandatory=$false)]
      [Object]$nsgRules
    ) 

    if($null -ne $nsgRules ) {
      $nsgRules = $nsgRules | ConvertFrom-Json
    }

    # Create a network security group  for database subnet
    az network nsg create `
    --resource-group $resourceGroupName `
    --name $networkSecurityGroupName

    # Associate the network security group to the Private subnet  (database subnet)
    az network vnet subnet update `
    --vnet-name $virtualNetworkName `
    --name $subnetName `
    --resource-group $resourceGroupName `
    --network-security-group $networkSecurityGroupName

    # rule that follows allows outbound access to the public IP addresses assigned to the Azure Storage service:

    foreach ($item in $nsgRules) {

      az network nsg rule create `
      --resource-group $resourceGroupName `
      --nsg-name $networkSecurityGroupName `
      --name $item.name `
      --access $item.access `
      --protocol $item.protocol `
      --direction $item.direction `
      --priority $item.priority `
      --source-address-prefix $item.sourceAddressPrefix `
      --source-port-range $item.sourcePortRange `
      --destination-address-prefix $item.destinationAddressPrefix `
      --destination-port-range $item.destinationPortRange `
      --description $item.description
    }

 <#    az network nsg rule create `
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

    # Create another outbound security rule that denies communication to the internet
<# 
    az network nsg rule create `
    --resource-group $resourceGroupName `
    --nsg-name $networkSecurityGroupName `
    --name "Deny-Internet-All" `
    --access Deny `
    --protocol "*" `
    --direction Outbound `
    --priority 110 `
    --source-address-prefix "VirtualNetwork" `
    --source-port-range "*" `
    --destination-address-prefix "Internet" `
    --destination-port-range "*"  `
    --description "Deny access to Internet." #>
}
