$logaSubscription = ""
$logaResourceGroupName = ""
$logaName = ""
$targetResourceGroupName = ""


Select-AzSubscription -SubscriptionName $logaSubscription 

 
$loga = Get-AzOperationalInsightsWorkspace -Name $logaName -ResourceGroupName $logaResourceGroupName

 
$resources = Get-AzResource -ResourceGroupName $targetResourceGroupName
foreach($resource in $resources){
    Set-AzDiagnosticSetting -Name $resource.ResourceName -ResourceId $resource.ResourceID -WorkspaceId $loga.ResourceId -Enabled $true -Verbose -ErrorAction SilentlyContinue
}
