
## Display Virtual Machines Name, Location, Resource Group Name and Tags
$resourceType = 'microsoft.compute/virtualMachines'
$query = "where type =~ '$resourceType' | project name, location, resourceGroup, tags"
$vm= Search-AzGraph -Query $query
$vm

## Display Virtual Machine count per location
$resourceType = 'microsoft.compute/virtualMachines'
$query = "where type =~ '$resourceType' | summarize count() by location"
$vmCount= Search-AzGraph -Query $query
$vmCount

## Count of Image SKU via location
$resourceType = 'microsoft.compute/virtualMachines'
$query = "where type =~ '$resourceType' | summarize count() by tostring(properties.storageProfile.imageReference.offer), location"
$vmCount= Search-AzGraph -Query $query
$vmCount

## List VMs that do not have Automatic Updates enabled
$resourceType = 'microsoft.compute/virtualMachines'
$query = "where type =~ '$resourceType' and properties.osProfile.windowsConfiguration.enableAutomaticUpdates == 'false' | summarize count() by location"
$vmCount= Search-AzGraph -Query $query
$vmCount

## Search for a specific VM
$vmName = 'UKS'
$resourceType = 'microsoft.compute/virtualMachines'
$query = "where type =~ 'microsoft.compute/virtualmachines' and name matches regex @'^$vmName(.*)[0-9]+$' | project name, resourceGroup, location, tags | order by name asc"
$searchVM = Search-AzGraph -Query $query
$searchVM
