# virtual-network-service-endpoints

https://docs.microsoft.com/en-us/azure/virtual-network/scripts/virtual-network-powershell-sample-multi-tier-application

# 1. CREATE STORAGE ACCOUNT AND A FILE SHARE
azurecli/1-storage-account.ps1

# 2. DOWNLOAD AZURE STORAGE EXPLORER 

https://azure.microsoft.com/en-us/products/storage/storage-explorer/

download right click storage account,  and connect to file share
upload a file and check it in storage account explorer

# 3. CREATE A VIRTUAL NETWORK WITH A WEBAPI SUBNET AND A DATABASE SUBNET 
azurecli/2-virtual-network

# 4. CREATE A SERVICE ENDPOINT
azurecli/3-service-endpoint

Ensure that communications with Azure Storage pass through the Service Endpoint. Add outbound rules to allow access to the Storage service but deny all other internet traffic.

 assign the Microsoft.Storage endpoint to the subnet webApiSubnet
 Deny all network access to a storage account
 Enable network access from a subnet (webApiSubnet)

 # 4. CREATE NETWORK SECURITY GROUP 
azurecli/4-network-security-group
Create a network security group
Associate the network security group to the Private subnet
rule that follows allows outbound access to the public IP addresses assigned to the Azure Storage service:
Create another outbound security rule that denies communication to the internet
Create a network security group
Associate the network security group to the public subnet
Allow access to web api

 # 5. CREATE VIRTUAL MACHINE AND AZURE BASTIO 
  azurecli/5-virtual-machines


# TEST
mount azure file share
\\logcorner07092022.file.core.windows.net\blog-file-share

username = storageAccountName
password = storageAccountKey


install Microsoft IIS on the myVMWeb virtual machine

Install-WindowsFeature -name Web-Server -IncludeManagementTools



https://adamtheautomator.com/powershell-iis/

 New-Item -ItemType Directory -Name 'MyWebsite' -Path 'C:\'
 New-Item -ItemType File -Name 'index.html' -Path 'C:\MyWebsite\'