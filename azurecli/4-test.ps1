# retrieve the connection string for the storage account into a variable 
$saConnectionString=$(az storage account show-connection-string `
  --name $storageAcctName `
  --resource-group myResourceGroup `
  --query 'connectionString' `
  --out tsv)

$acctKey = ConvertTo-SecureString -String $saConnectionString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$storageAcctName", $acctKey
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$storageAcctName.file.core.windows.net\my-file-share" -Credential $credential