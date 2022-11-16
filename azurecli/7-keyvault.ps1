$resourceGroup = "virtual-network-service-endpoints"

az keyvault create --name "logcornersecretstore" -g $resourceGroup


az keyvault secret set --vault-name "logcornersecretstore" --name "ConnectionString" --value "DefaultEndpointsProtocol=https;AccountName=logcorner07092022;AccountKey=oPs2jzdLio7ilnUhsb60tu/DEIwn1UkAXMmSStYvqmePDDtD9OINu0PIoUUdi47AY1CNfb/+qByl+AStz5LgCg==;EndpointSuffix=core.windows.net"

az vm identity assign --name "webApiServer" --resource-group $resourceGroup


az keyvault set-policy --name 'logcornersecretstore' --object-id '844b833c-9774-417d-acea-ac3327c1d6cb' --secret-permissions  get list set delete