$vaults = Get-AzResource | Where-Object{$_.ResourceType -eq ('Microsoft.KeyVault/vaults')} 
$wsID = Get-AzOperationalInsightsWorkspace -Name $logWsName -ResourceGroupName $logWsRGName
$logWsName = "xxxxxx"
$logWsRGName = "xxxxxx"
$diagName = "KeyVault-Diagnostics-LOGA"

foreach($vault in $vaults){
        Set-AzDiagnosticSetting -Name KeyVault-Diagnostics -ResourceId $vault.ResourceID `
         -Category AuditEvent -MetricCategory AllMetrics -Enabled $true -WorkspaceId $wsID.ResourceId
        #Get-AzDiagnosticSetting -ResourceId $vault.ResourceID
        }
