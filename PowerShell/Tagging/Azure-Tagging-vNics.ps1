  <#
  .SYNOPSIS 
    This script inputs a CSV file to update Tagging

    .DESCRIPTION
    In parrallel this runbook removes any existing tags on a particular vNIC then updates the vNIC with the new tags identified within the CSV

    .REQUIREMENTS 
    This script requires an input from CSV 

    .AUTHOR: Sean McDonnell  EDIT DATE: 14/01/2021

    .EXAMPLES: .\Azure-Tagging.ps1 -DeployCSV Update-Tagging-vNICs.csv -subID xxxx-xxxxx-xxxxx-xxxxxx-xxxxx
#>

# Load Azure PowerShell Module
#Import-Module -Name Az -ErrorAction SilentlyContinue

# Connect to Azure Resource Manager
#Login-AzAccount

Param (
	[Parameter(Mandatory=$true)][string]$DeployCSV,
  	[Parameter(Mandatory=$true)][string]$subID
)

#Log in to subscription
Select-AzSubscription -SubscriptionId $subID

# Check Parameters are not blank
if ($DeployCSV -eq "") {
    Write-Host "Missing -DeployCSV option. We need to be passed a CSV file for deployment. Terminating script"
    Exit
}

# Check that the CSV file exists
if (!(Test-Path -Path $DeployCSV)) {
    Write-Host "Deployment CSV file $DeployCSV does not exist. Terminating script"
    Exit
}

# Delete exisitng tags from vNICS
function DeleteTag {
    Param ($rgName, $nicName)
    
    Write-Host "Deleting Existing Tags for $nicName vNic"
    $vNics = Get-AzResource -Name $nicName -ResourceGroupName $rgName -ResourceType "Microsoft.Network/networkInterfaces"
    foreach($vNic in $vNics){
        Set-AzResource -Tag @{} -ResourceId $vNic.Id -Force -ErrorAction Ignore -AsJob
    }
}

# Add tags to vNICs
function AddTag {
    Param ($rgName, $nicName, $nicTags)
    
    $vNics = Get-AzResource -Name $nicName -ResourceGroupName $rgName -ResourceType "Microsoft.Network/networkInterfaces"
    foreach($vNic in $vNics){
    Write-Host "Adding new Tags for $nicName vNic"

     # Split the tags out as we can have more than one
    $newTags = $nicTags.Split(";")
    $tags = $vNic.Tags

    if ($tags.Count -eq 0) {
        $tags = New-Object System.Collections.Hashtable #System.Collections.ArrayList;
    }

    $tagsUpdated = $false
    
    ForEach($newTag in $newTags) 
    {
        $Key = ($newTag.Split("=")[0])
        $Value = ($newTag.Split("=")[1])
        $tags.Add($key, $value)
    }

    Set-AzResource -Tag $Tags -ResourceId $vNic.Id -Force -ErrorAction Ignore -AsJob}
}

# Import the CSV file and start deleting tags from vNIC
Import-Csv -Path $DeployCSV | ForEach-Object { DeleteTag -rgName $_.ResourceGroup -nicName $_.nicName }

# Wait for deletion of tags to finish for all vNICs
Get-Job | Wait-Job | Format-Table -AutoSize

# Import the CSV file and start adding tags from vNICS
Import-Csv -Path $DeployCSV | ForEach-Object { AddTag -rgName $_.ResourceGroup -nicName $_.nicName -nicTags $_.Tags }

# Wait for adding of tags to finish for all vNICS
Get-Job | Wait-Job | Format-Table -AutoSize

# Clear job history
Remove-Job *
