$resourceGroup = "virtual-network-service-endpoints"

$storageAcct = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name "logcorner97377" 
$shareName ="logcorner-data-share"
$output =Get-AzStorageFile `
    -Context $storageAcct.Context `
    -ShareName $shareName `
    -Path "demo\" | Get-AzStorageFile

Write-Host $output.ShareFileClient.Path

if ( $null -ne $output ){

    foreach ($file in $output){
        Get-AzStorageFileContent `
            -Context $storageAcct.Context `
            -ShareName $shareName `
            -Path $file.ShareFileClient.Path `
            -Destination $file.ShareFileClient.Name
    }
}
else {
    Write-Host "no files to download"
}
