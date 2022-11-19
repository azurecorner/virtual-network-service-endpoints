Function NewVirtualMachine
{
    [OutputType([String])]
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$virtualMachineName,
      [parameter(Mandatory=$true)]
      [string]$virtualNetworkName,
      [parameter(Mandatory=$true)]
      [string]$subnetName,
      [parameter(Mandatory=$true)]
      [string]$image,
      [parameter(Mandatory=$true)]
      [string]$adminUsername,
      [parameter(Mandatory=$true)]
      [securestring]$adminPassword,
      [parameter(Mandatory=$false)]
      [string]$publicIpName

    ) 
# Create a VM in the Public subnet 
  . {
    az vm create `
      --resource-group $resourceGroupName `
      --image $image `
      --name $virtualMachineName `
      --vnet-name $virtualNetworkName `
      --subnet $SubnetName `
      --public-ip-address '""' `
      --nsg '""' `
      --admin-username $adminUsername --admin-password $adminPassword

      if(-not ( [string]::IsNullOrEmpty($publicIpName ))) {
        # Create a public ip address
        az network public-ip create --name $publicIpName --resource-group $resourceGroupName --allocation-method Static
        
        az network nic ip-config update `
          --name "ipconfig$($virtualMachineName)" `
          --nic-name "$($virtualMachineName)VMNic" `
          --resource-group $resourceGroupName `
          --public-ip-address $publicIpName
      }

      # foreach ($item in $managedIdentities) {
      #   az vm identity assign --name "webApiServer" --resource-group $resourceGroupName
      # }

     <#  $id =(az vm show --name $virtualMachineName `
      --resource-group $resourceGroupName `
      --query 'networkProfile.networkInterfaces[].id' `
      --output tsv)  #>

      $spId = $(az resource list -n $virtualMachineName --query [*].identity.principalId --out tsv)

      Write-Host $spId
      Return 
  
} | Out-Null
Return $spId
}
