# az network public-ip create `
#     --resource-group myResourceGroup `
#     --name myPublicIP `
#     --version IPv4 `
#     --sku Standard `
#     --zone 1 2 3

# Create a VM in the Public subnet 

az vm create `
  --resource-group myResourceGroup `
  --image Win2019Datacenter `
  --name myVmPublic `
  --vnet-name myVirtualNetwork `
  --public-ip-address myPublicIP `
  --public-ip-sku Standard `
  --subnet Public `
  --admin-username 'username' --admin-password 'Password123!'

  #az network bastion create --name MyBastion --public-ip-address myPublicIP --resource-group MyResourceGroup --vnet-name myVirtualNetwork --location eastus
 

# Create a VM in the Public subnet 

az vm create `
  --resource-group myResourceGroup `
  --image Win2019Datacenter `
  --name myVmPrivate  `
  --vnet-name myVirtualNetwork `
  --public-ip-address myPrivateIP `
  --public-ip-sku Standard `
  --subnet Public `
  --admin-username 'username' --admin-password 'Password123!'