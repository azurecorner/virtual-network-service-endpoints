# retrieve the connection string for the storage account into a variable 
$saConnectionString=$(az storage account show-connection-string `
  --name $storageAcctName `
  --resource-group myResourceGroup `
  --query 'connectionString' `
  --out tsv)

  $storageAcctName="logcorner07092022"
  $resourceGroup = "virtual-network-service-endpoints"

  $saConnectionString = (Get-AzStorageAccount -ResourceGroupName  $resourceGroup -Name $storageAcctName).Context.ConnectionString

$acctKey = ConvertTo-SecureString -String $saConnectionString -AsPlainText -Force

$acctKey='DefaultEndpointsProtocol=https;AccountName=logcorner07092022;AccountKey=Q7Lu2aWiKfYlnc+61fE4iLpzQ8wt6ZoKO8WNTpIiNVvEk3OFMVWZO6K4aiIeO5uBJ2EJXK1/xTGU+AStQdxPfQ==;EndpointSuffix=core.windows.net'
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$storageAcctName", $acctKey
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$storageAcctName.file.core.windows.net\my-file-share" -Credential $credential