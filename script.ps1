$resourceGroup = "virtual-network-service-endpoints"
$location = "westeurope"
$random =97377 #( Get-Random -Minimum 10000 -Maximum 99999 ).ToString('00000')

$StorageAccountPrefixName ="logcorner"
$shareName ="logcorner-data-share"

#create ressource group
New-AzResourceGroup -Name $resourceGroup -Location $location

#create storage account
$account = New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name $StorageAccountPrefixName$random  `
  -Location $location `
  -SkuName Standard_RAGRS `
  -Kind StorageV2

  # create a file share
  New-AzRmStorageShare `
    -ResourceGroupName $resourceGroup `
    -StorageAccountName $account.StorageAccountName `
    -Name $shareName 
  # create a file directory      
New-AzStorageDirectory `
    -Context $account.Context `
    -ShareName $shareName `
    -Path "demo"

  Write-Host $account