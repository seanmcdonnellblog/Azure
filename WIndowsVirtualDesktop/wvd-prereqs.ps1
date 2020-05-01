# Install and Import RDS Module
Install-Module Microsoft.RDInfra.RDPowershell
Import-Module -Name Microsoft.RDInfra.RDPowershell

# Install and Import AzureAD Module
Install-Module -Name AzureAD
Import-Module -Name AzureAD

# Don't change the deploymenturl
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

# Creation of the WVD tenant, this is a one-time activity
$tenantCreation = New-RdsTenant -Name $wvdTenantName -AadTenantId $aadContext.TenantId -AzureSubscriptionId $subID

# Create the Context for AzureAD and create new service principal
$aadContext = Connect-AzureAD
$svcPrincipal = New-AzureADApplication -AvailableToOtherTenants $true -DisplayName "Windows Virtual Desktop Svc Principal"
$svcPrincipalCreds = New-AzureADApplicationPasswordCredential -ObjectId $svcPrincipal.ObjectId

# View Credentials, Applicaiton ID
$svcPrincipal.AppId
# Password
$svcPrincipalCreds.Value
# Tenant ID
$aadContext.TenantId.Guid

# Assign RDS Owner Role to Tenant
$myTenantName = (Get-RdsTenant).TenantName
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -ApplicationId $svcPrincipal.AppId -TenantName $myTenantName

# Verify sign in
$creds = New-Object System.Management.Automation.PSCredential($svcPrincipal.AppId, (ConvertTo-SecureString $svcPrincipalCreds.Value -AsPlainText -Force))
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -Credential $creds -ServicePrincipal -AadTenantId $aadContext.Tenant.Id.Guid
