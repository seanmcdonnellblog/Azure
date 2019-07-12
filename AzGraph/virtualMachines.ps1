# Global Variables
$resourceType = 'microsoft.compute/virtualMachines'
$vmSize = 'properties.hardwareProfile.vmSize'
$osProfile = 'properties.storageProfile.osDisk.osType'
$imageOffer = 'properties.storageProfile.imageReference.offer'

# Display Virtual Machines Name, Location, Resource Group Name and Tags
$query = "where type =~ '$resourceType' | project name,resourceGroup, location, size = $vmSize, License = properties.licenseType, subscriptionId, type, os = $osProfile, tags"
$vm= Search-AzGraph -Query $query
$vm

# Display Virtual Machine count per location
$query = "where type =~ '$resourceType' | summarize count() by location"
$vmCount= Search-AzGraph -Query $query
$vmCount

# Display Count of VM Sizes
$query = "where type =~ '$resourceType' | project  SKU = tostring($vmSize)| summarize count() by SKU"
$vmCountbySKU= Search-AzGraph -Query $query
$vmCountbySKU 

# Count of Image SKU via location
$query = "where type =~ '$resourceType' | summarize count() by tostring($imageOffer), location"
$vmCount= Search-AzGraph -Query $query
$vmCount

## List VMs that do not have Automatic Updates enabled
$query = "where type =~ '$resourceType' and properties.osProfile.windowsConfiguration.enableAutomaticUpdates == 'false' | summarize count() by location"
$vmCount= Search-AzGraph -Query $query
$vmCount

# Search for a specific VM
$vmName = 'UKS'
$query = "where type =~ 'microsoft.compute/virtualmachines' and name matches regex @'^$vmName(.*)[0-9]+$' | project name, resourceGroup, location, tags | order by name asc"
$searchVM = Search-AzGraph -Query $query
$searchVM
