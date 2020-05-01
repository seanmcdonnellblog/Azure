[CmdletBinding()]
        Param(
        	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        	[String] $location,

	    	  [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	  [string] $resourceGroup,
 
	    	  [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	  [string] $storAccountName,

          [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	  [string] $storSKU,

          [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	  [string] $storType
    	)

$rgName = Get-AzResourceGroup -ResourceGroupName $resourceGroup -ErrorAction SilentlyContinue

  if ($rgName) {
        Write-Host "Resource Group: $resourceGroup Already Exists"
    } else {
        Write-Host "Creating Resource Group: $resourceGroup"
        # Create new Resource Group
        $newRG = New-AzResourceGroup -Name $resourceGroupName -Location $location -Force -ErrorAction Stop
        
        # Check if the creation was successful
        if ($newRG.ProvisioningState -eq "Succeeded") {
            Write-Host "Resource Group: $resourceGroup created successfully"
        } else {
            Write-Host $newRG
            Write-Host "Resource Group: $resourceGroup creation failed. Terminating"
            Exit
        }
    }

    $sa = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storAccountName -ErrorAction SilentlyContinue

    if ($sa) {
        Write-Host "Storage Account: $storAccountName Already Exists"
    } else {
        Write-Host "Creating Storage Account: $storAccountName"

        $newSA = New-AzStorageAccount -Name $storAccountName `
            -Location $location `
            -SkuName $storSKU `
            -Kind $storType `
            -ResourceGroupName $resourceGroup -ErrorAction Stop

        # Check if the creation was successful
        if ($newSA.ProvisioningState -eq "Succeeded") {
            Write-Host "Storage Account: $storAccountName created successfully"
        } else {
            Write-Host $newSA
            Write-Host "Storage Account: $storAccountName creation failed. Terminating"
            Exit
        }
    }
