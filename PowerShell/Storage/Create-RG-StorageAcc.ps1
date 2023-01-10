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

$existRG = Get-AzResourceGroup -ResourceGroupName $resourceGroup -ErrorAction SilentlyContinue
$existSA = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storAccountName -ErrorAction SilentlyContinue

if (!$existRG) {
    Write-Verbose "Creating Resource Group: $resourceGroup"
    $newRG = New-AzResourceGroup -Name $resourceGroup -Location $location -Force -ErrorAction Stop
    if (!($newRG.ProvisioningState -eq "Succeeded")) {
        Write-Verbose "Resource Group: $resourceGroup creation failed. Terminating"
        Exit
    }
    Write-Verbose "Resource Group: $resourceGroup created successfully"
} else {
    Write-Verbose "Resource Group: $resourceGroup Already Exists"
}

if (!$existSA) {
    Write-Verbose "Creating Storage Account: $storAccountName"
    $newSA = New-AzStorageAccount -Name $storAccountName -Location $location -SkuName $storSKU -Kind $storType -ResourceGroupName $resourceGroup -Force -ErrorAction Stop
    if (!($newSA.ProvisioningState -eq "Succeeded")) {
        Write-Verbose "Storage Account: $storAccountName creation failed. Terminating"
        Exit
    }
    Write-Verbose "Storage Account: $storAccountName created successfully"
} else {
    Write-Verbose "Storage Account: $storAccountName Already Exists"
}
