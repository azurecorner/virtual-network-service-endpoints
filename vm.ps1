$resourceGroup = "virtual-network-service-endpoints"
$vnetName ="logcorner-vnet"
$location = "westeurope"

New-AzVm `
    -ResourceGroupName $resourceGroup `
    -Name 'DataServer' `
    -Location $location  `
    -VirtualNetworkName $vnetName `
    -SubnetName "DatabaseSubnet" `
    -SecurityGroupName 'DataServerNetworkSecurityGroup' `
    -PublicIpAddressName 'DataServerPublicIpAddress' `
    -OpenPorts 80,3389

#install powershell az module in the VM
    # Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -VMName 'DataServer' -CommandId 'RunPowerShellScript' -ScriptString 'Install-Module -Name Az.Account -Scope AllUsers  -Repository PSGallery -Force'
    # Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -VMName 'DataServer' -CommandId 'RunPowerShellScript' -ScriptString 'Install-Module -Name Az.Storage -Scope AllUsers  -Repository PSGallery -Force'

    # Connect-AzAccount