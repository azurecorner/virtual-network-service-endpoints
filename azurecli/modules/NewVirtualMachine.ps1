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
      [securestring]$adminPassword
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

      $id =(az vm show --name $virtualMachineName `
      --resource-group $resourceGroupName `
      --query 'networkProfile.networkInterfaces[].id' `
      --output tsv) 

      $Return = $id

      
      Write-Host  $Return
      Return 
  
} | Out-Null
Return $Return
}
