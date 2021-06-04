<# 
 .DESCRIPTION
  This script will create or use an Existing Key Vault, followed by adding 3 secrets for a service principal
    - ClientID 
    - ClientSecret
    - TenantID
   Once the key vault is created, the service principal is provided Get and List permissions to fetch the secrets from the Key Vault.  
 .PARAMETER -keyVaultName
  The name of the existing or new Key Vault
 
 .PARAMETER -Location
  The name of the Key Vault
 
 .PARAMETER -servicePrinicpalName
  The name of the existing or new Key Vault
 .PARAMETER -clientID
  The Client or Object ID of the existing Service Principal. This is passed in and converted to a secure string
  .PARAMETER -clientSecret
  The Service Principal Secret, this is obtained only at the time of the Service Principal creation. This is passed in and converted to a secure string
  
  .PARAMETER -tenantID
  The ID of the tenant. This is passed in and converted to a secure string
 .EXAMPLE
  # Test ARM template file with parameters, variables, functions, resources and outputs:
  .\keyvault-AzureDevOps.ps1 -keyVaultName AZ-DEVOPS01-KV  -Location "UK South" -resourceGroup UKS-AZUREBUILD-RG -servicePrinicpalName Azure-Build-ServicePrincipal -clientID xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -clientSecret xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -tenantID xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx 
#>

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
