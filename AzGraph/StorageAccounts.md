# Azure Search AzGraph Examples

## Find tags for Storage Accounts
$resourceType = 'microsoft.storage/storageAccounts'
$query = "where type =~ '$resourceType' | project name, resourceGroup, type, location, tags"
$storageTags = Search-AzGraph -Query $query
$storageTags

## Find any public facing Storage Accounts
$resourceType = 'microsoft.storage/storageAccounts'
$query = "where type =~ '$resourceType' | project tag = tostring(tags.Service) | summarize count() by tag"
$storageTags = Search-AzGraph -Query $query
$storageTags

## Count count of Storage Accounts by location
$resourceType = 'microsoft.storage/storageAccounts'
$query =  "where type =~ '$resourceType' | summarize count() by location"
$storageAccountCount = Search-AzGraph -Query $query
$storageAccountCount

## Find any Storage accounts that are not VNET integrated (Accessible from Internet)
$resourceType = 'microsoft.storage/storageAccounts'
$query =  "where type =~ '$resourceType' and aliases['Microsoft.Storage/storageAccounts/networkAcls.defaultAction'] == 'Allow' | project name, kind, location"
$storagePuplicAccess = Search-AzGraph -Query $query
$storagePuplicAccess

## Find any storage accounts which are not located in Primary Loation UK South
$resourceType = 'microsoft.storage/storageAccounts'
$query = "where type =~ '$resourceType' and aliases['Microsoft.Storage/storageAccounts/primaryLocation'] != 'uksouth' | project name, location, resourceGroup"
$storagePuplicAccess = Search-AzGraph -Query $query
$storagePuplicAccess
