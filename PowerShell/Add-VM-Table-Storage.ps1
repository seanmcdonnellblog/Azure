<#

.

.

.

#>
param(
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$vaultName,
	
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$storageKey,
 
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$StorageAccountName
)

$vms = Get-AzResource -ExpandProperties -ResourceType Microsoft.Compute/virtualMachines 
$vNics = Get-AzResource -ExpandProperties -ResourceType Microsoft.Network/networkInterfaces
#$vaultName = "UKS-CORE-KV"
#$storageKey = 'StorageAccountKey'
#$StorageAccountName = 'ukscorestdtable01'
$TableName = 'vmHistory'
$StorageAccountAccessKey = (Get-AzKeyVaultSecret -vaultName $vaultName -name $storageKey).SecretValueText

$Entities = @()
$i = 1

foreach($vm in $vms){
    $nic = $vNics | Where {$_.Properties.virtualMachine.id -eq $VMId}
    $VMId = $vm.Id
    If($vm.tags.service -eq $null){
        $vm.Tags.service = "Not Assigned"
    }
    If($vm.tags.role -eq $null){
        $vm.Tags.role = "Not Assigned"
    }
    $pro1 = @{
        PartitionKey = 'virtualMachine'
        RowKey = "$i"
        vmName = $vm.Name
        ResourceGroupName = $vm.ResourceGroupName
        Location = $vm.location
        VMSize = $vm.hardwareProfile.vmSize
        OperatingSystem = $vm.Properties.storageProfile.imageReference.Offer
        IPAdress = $nic.Properties.ipConfigurations.properties.privateIPAddress
        OSDisk = $vm.Properties.storageProfile.osDisk.name
        ServiceTag = $vm.Tags.Service
        RoleTag = $vm.Tags.Role
    }
    $pro1 = $pro1 | Sort-Object $_.Name
    $entity1 = New-Object psobject -Property $pro1
    New-AzureTableEntity -StorageAccountName $StorageAccountName -StorageAccountAccessKey $StorageAccountAccessKey -TableName $TableName -Entities $entity1 -Verbose
    $pro1 = ""
    $entity1 = ""
    $i++
}


#return all entities, and convert datetime fields
$QueryString = "(PartitionKey eq 'virtualMachine') and (ServiceTag eq 'CRM')"
$SearchResult = Get-AzureTableEntity -StorageAccountName $StorageAccountName -StorageAccountAccessKey $StorageAccountAccessKey -TableName $TableName -QueryString $QueryString -ConvertDateTimeFields $true -GetAll $true -Verbose

$name = $SearchResult.vmName
do {
    $name = $name -replace '\d$', ([int][string]$name[-1] + 1)
} while ($table.StorageAccountName -contains $name)

$name
