# Work with the Azure Resource Graph
The following examples show how to query Azure Storage accounts via the Azure Resource Graph. The Azure Resource Graph query lanaguage is built on the Azure Data Explorere Query Language (Kusto) and supports tabular data operators such as summarize, count and functions ( tostring() ago)

https://docs.microsoft.com/en-us/azure/kusto/query/queries

To get started, you will need to install the Az.ResourceGraph Module<br/>
**Install-Module -Name Az.ResourceGraph**<br/>
**Get-Command -Module 'Az.ResourceGraph**

Help commands<br/>
**Get-Help Search-AzGraph -Examples**

## Find tags for Storage Accounts
```$resourceType = 'microsoft.storage/storageAccounts'<br/>
```$query = "where type =~ '$resourceType' | project name, resourceGroup, type, location, tags"
PS C:\>$storageTags = Search-AzGraph -Query $query
PS C:\>$storageTags

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
$storageLocation = Search-AzGraph -Query $query
$storageLocation
