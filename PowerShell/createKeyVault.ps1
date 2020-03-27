<# 
 .DESCRIPTION
  This script will create or use an Existing Key Vault, followed by adding 3 secrets for a service principal
    - ClientID 
    - ClientSecret
    - TenantID
   Once the key vault is created, the service principal is provided Get and List permissions to fetch the keys.  

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

[CmdLetBinding()]
    param (
	[Parameter(Mandatory=$true)]
	    [string]$keyVaultName,

        [Parameter(Mandatory=$true)]
	    [string]$resourceGroup,

        [Parameter(Mandatory=$true)]
	    [string]$Location,

        [Parameter(Mandatory=$true)]
	    [string]$servicePrinicpalName,

        [Parameter(Mandatory=$true)]
	    [string]$clientID,

        [Parameter(Mandatory=$true)]
	    [string]$clientSecret,

        [Parameter(Mandatory=$true)]
	    [string]$tenantID
    )

$securedclientID =  ConvertTo-SecureString -String $clientID -AsPlainText -Force
$securedclientSecret =  ConvertTo-SecureString -string $clientSecret -AsPlainText -Force
$securedtenantID =  ConvertTo-SecureString -string $tenantID -AsPlainText -Force
$keyVaultName = "AZ-DEVOPS02-KV"
$resourceGroup = "UKS-AZUREBUILD-RG"

# Create New KeyVault
$existingVault = Get-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroup

if(!$existingVault){
    Write-Host "Key Vault $($keyVaultName) Does not exist"
    $keyVault = New-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroup -Location $Location

}elseif($existingVault){
    write-host "Vault $($existingVault.VaultName) already exists, using this Vault"
}

Start-Sleep -Seconds 20

# Get the Service Principal 
$spApp = Get-AzureADApplication -Filter "DisplayName eq '$($servicePrinicpalName)'"

# Set Access Policy for Key Vault
$setKVAccess = Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -ResourceGroupName $resourceGroup -ObjectId $spApp.ObjectId -PermissionsToSecrets Get,List

# Set Secrets to Key Vault
$appID = Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "ClientID" -SecretValue $securedclientID
$secret = Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "ClientSecret" -SecretValue $securedclientSecret
$tenantID = Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "TenantID" -SecretValue $securedtenantID 
