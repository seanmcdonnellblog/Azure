[CmdletBinding()]
        Param(
        	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        	[String] $appID,

	    	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string] $appSecret,
 
	    	[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
	    	[string] $subID,
    	)

# Define GRAPH API Token details for Service Principal
$ReqTokenBody = @{
    Grant_Type    = "client_credentials"
    client_Id     = $appID
    Client_Secret = $appSecret
    Scope         = "https://graph.microsoft.com/.default"
    Tenant_Name   = $subID
}

# Obtain GRAPH API Token for Service Principal
$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$($ReqTokenBody.Tenant_Name)/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

$TokenResponse
