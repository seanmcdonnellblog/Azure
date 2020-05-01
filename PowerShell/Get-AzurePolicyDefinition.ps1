$policy = @()
$policies = Get-AzPolicyDefinition

$policy += $policies | select @{Name="Display Name";expression={$_.Properties.displayName}},`
                            @{Name="Description";expression={$_.Properties.description}},`
                            @{Name="Category";expression={$_.Properties.metadata.category}},`
                            @{Name="Policy ID";expression={$_.Name}},`
                            @{Name="Policy Type";expression={$_.Properties.policyType}}
