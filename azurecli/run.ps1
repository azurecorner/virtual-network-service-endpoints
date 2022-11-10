$resourceGroup = "virtual-network-service-endpoints"
$location="westeurope"

az group create `
  --name $resourceGroup `
  --location $location


# ./1-storage-account.ps1
./2-virtual-network.ps1
./3-virtual-machines.ps1



./7-devops.ps1