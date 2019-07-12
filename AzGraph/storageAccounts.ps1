# Global Variables
$resourceType = 'microsoft.storage/storageAccounts'

## Find tags for Storage Accounts
$query = "where type =~ '$resourceType' | project name, resourceGroup, type, location, tags"
$storageTags = Search-AzGraph -Query $query
$storageTags

## Display Count for the Service Tag
$query = "where type =~ '$resourceType' | project tag = tostring(tags.Service) | summarize count() by tag"
$storageTags = Search-AzGraph -Query $query
$storageTags

## Count count of Storage Accounts by location
$query =  "where type =~ '$resourceType' | summarize count() by location"
$storageAccountCount = Search-AzGraph -Query $query
$storageAccountCount

## Find any Storage accounts that are not VNET integrated (Accessible from Internet)
$query =  "where type =~ '$resourceType' and aliases['Microsoft.Storage/storageAccounts/networkAcls.defaultAction'] == 'Allow' | project name, kind, location"
$storagePuplicAccess = Search-AzGraph -Query $query
$storagePuplicAccess

## Find any storage accounts which are not located in Primary Loation UK South
$query = "where type =~ '$resourceType' and aliases['Microsoft.Storage/storageAccounts/primaryLocation'] != 'uksouth' | project name, location, resourceGroup"
$storageLocation = Search-AzGraph -Query $query
$storageLocation
