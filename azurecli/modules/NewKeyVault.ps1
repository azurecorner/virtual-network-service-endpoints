Function NewKeyVault
{
    Param
    (
      [parameter(Mandatory=$true)]
      [string]$resourceGroupName,
      [parameter(Mandatory=$true)]
      [string]$keyVaultName,
      [parameter(Mandatory=$false)]
      [Object]$secrets,
      [Object]$secretPermissions
    )
    
    az keyvault create --name $keyVaultName -g $resourceGroupName

    if($null -ne $secrets) {
        $secrets = $secrets | ConvertFrom-Json
  
        foreach ($secret in $secrets) {
                az keyvault secret set --vault-name $keyVaultName --name $secret.name --value $secret.value
        }
   }
    if($null -ne $secretPermissions) {
        $secretPermissions = $secretPermissions | ConvertFrom-Json
   
        foreach ($policy in $secretPermissions) {
            az keyvault set-policy --name $keyVaultName --resource-group $resourceGroupName --object-id $policy.objectId --secret-permissions $policy.value
        } 
   }
 }