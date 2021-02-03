Install-Module -Name Az.ResourceGraph -Force
# Global Variables
$resourceType = 'microsoft.network/virtualNetworks'

# Display Virtual Machines Name, Location, Resource Group Name and Tags
$query = "Resources | where type =~ '$resourceType'" 
$allVnets= Search-AzGraph -Query $query

foreach($vnet in $allVnets){

$vnetTable += $allVnets |select @{Name="VNET Name";expression={$_.Name}},`
                    @{Name="Resource Group Name";expression={$_.ResourceGroup}},`
                    @{Name="VNET Location";expression={$_.Location}},`
                    @{Name="Subscription";expression={$_.subscriptionId}},`
                    @{Name="Address Space";expression={$_.properties.addressSpace.addressPrefixes}},`
                    @{Name="Subnet Names";expression={[string]::Join(", ",($_.properties.subnets.name.split(" ")))}},`
                    @{Name="Subnet Addresses";expression={[string]::Join(", ",($_.properties.subnets.properties.addressPrefix.split(" ")))}}
}

$vnetTable
