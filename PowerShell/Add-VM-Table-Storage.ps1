[CmdletBinding()]
        Param(
        	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        	[String] $vaultName,

	    	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$storageKey,
 
	    	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$StorageAccount,

            	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$table,

        	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$resourceGroup
    	)	

$vms = Get-AzResource -ExpandProperties -ResourceType Microsoft.Compute/virtualMachines 
$vNics = Get-AzResource -ExpandProperties -ResourceType Microsoft.Network/networkInterfaces

Function add-VMHistory
{
    [CmdletBinding()]
        param(
        	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        	[String] $vaultName,

	    	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$storageKey,
 
	    	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$StorageAccount,

        	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$table,

        	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string]$resourceGroup
    	)

    Begin {   
            $StorageAccountAccessKey = (Get-AzKeyVaultSecret -vaultName $vaultName -name $storageKey).SecretValueText
            $tableName = Get-AzTableTable -resourceGroup $resourceGroup -TableName $table -storageAccountName $storageAccount
            $removeTableRows =  Get-AzTableRowAll -Table $TableName | Remove-AzTableRow -Table $tableName

            if(!$removeTableRows)
            {
                Write-host "No Entries found in table: $tableName , nothing to delete" -ForegroundColor Green
            }else
            {
                write-host "Entries found and will be deleted..." -ForegroundColor Yellow
            }
       }
 
       Process {
          $Entities = @()
          $i = 1
          Write-Verbose "In the process block"
          foreach($vm in $vms){
                $nic = $vNics | Where {$_.Properties.virtualMachine.id -eq $VMId}
                $VMId = $vm.Id
                    If(!$vm.tags.service){
                        $vm.Tags.service = "TAG MISSING"
                    }
                    If(!$vm.tags.role){
                        $vm.Tags.role = "TAG MISSING"
                    }
                    If(!$vm.tags.Environment){
                        $vm.Tags.Environment = "TAG MISSING"
                    }
            $pro1 = @{
                PartitionKey = 'virtualMachine'
                RowKey = "$i"
                vmName = $vm.Name
                ResourceGroupName = $vm.ResourceGroupName
                Location = $vm.location
                VMSize = $vm.hardwareProfile.vmSize
                OperatingSystem = $vm.Properties.storageProfile.imageReference.Offer
                IPAddress = $nic.Properties.ipConfigurations.properties.privateIPAddress
                Subnet = $nic.Properties.IpConfigurations.Properties.Subnet.id | foreach{$_.split("/")[10]}
                OSDisk = $vm.Properties.storageProfile.osDisk.name
                ServiceTag = $vm.Tags.Service
                RoleTag = $vm.Tags.Role
                Environment = $vm.Tags.Environment
            }

            $pro1 = $pro1 | Sort($_.Name)
            $entity1 = New-Object psobject -Property $pro1
            New-AzureTableEntity -StorageAccountName $StorageAccount -StorageAccountAccessKey $StorageAccountAccessKey -TableName $TableName -Entities $entity1 -Verbose
            $pro1 = ""
            $entity1 = ""
            $i++
        }
       }
 
       End {
            $QueryString = "(PartitionKey eq 'virtualMachine') and (ServiceTag eq 'CRM')"
            $SearchResult = Get-AzureTableEntity -StorageAccountName $StorageAccount -StorageAccountAccessKey $StorageAccountAccessKey -TableName $TableName -QueryString $QueryString -ConvertDateTimeFields $true -GetAll $true -Verbose
            $name = $SearchResult.vmName | Select-Object -Last 1
            do {
                $name = $name -replace '\d$', ([int][string]$name[-1] + 1)
            } while ($tableName.StorageAccountName -contains $name)
            Write-Host ""
            write-host "Next VM that will be built will be $name" -ForegroundColor Green
       }
}
add-VMHistory -vaultName $vaultName -storageKey $StorageKey -StorageAccount $storageAccount -table $table -resourceGroup $resourceGroup

#$vaultName = "UKS-CORE-KV"
#$storageKey = 'StorageAccountKey'
#$StorageAccountName = 'ukscorestdtable01'

    
