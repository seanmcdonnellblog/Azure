<# 
 .DESCRIPTION
  This script will add a diagnostic setting for all KeyVaults within a Subscription to one Log Analytics Workspace. 
  The Diaganostic setting will set the AuditEvent only, this can be changed to also push additional logs also.   
     
 .PARAMETER -logWsName
  The name of the existing Log Analytics Workspace
 
 .PARAMETER -logWsRGName
  The name of the Log Analytics Workspace Resource Group
 
 .PARAMETER -diagName
  The name of the Diagnostic Setting e.g KeyVault-Diagnostics
  
 .EXAMPLE
 .\Azure-KeyVault-Diagnostic.ps1 -logWsName testWS01 -logWsRGName testWS01-RG -diagName KeyVault-Diagnostics-LOGA
  
#>

[CmdLetBinding()]
    param (
	[Parameter(Mandatory=$true)]
	       [string]$logWsName,

        [Parameter(Mandatory=$true)]
	       [string]$logWsRGName,

        [Parameter(Mandatory=$true)]
	       [string]$diagName
    )

$vaults = Get-AzResource | Where-Object{$_.ResourceType -eq ('Microsoft.KeyVault/vaults')} 
$wsID = Get-AzOperationalInsightsWorkspace -Name $logWsName -ResourceGroupName $logWsRGName

foreach($vault in $vaults){
        Set-AzDiagnosticSetting -Name KeyVault-Diagnostics -ResourceId $vault.ResourceID `
         -Category AuditEvent -MetricCategory AllMetrics -Enabled $true -WorkspaceId $wsID.ResourceId       
}
