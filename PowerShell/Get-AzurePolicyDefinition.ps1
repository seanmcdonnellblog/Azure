# Create an empty Hash Table
$policy = @()

# Get All Policy Definitions
$policies = Get-AzPolicyDefinition

# Polulate hash table with Policy Display Name, Description, Category, ID and Type
$policy += $policies | select @{Name="Display Name";expression={$_.Properties.displayName}},`
                            @{Name="Description";expression={$_.Properties.description}},`
                            @{Name="Category";expression={$_.Properties.metadata.category}},`
                            @{Name="Policy ID";expression={$_.Name}},`
                            @{Name="Policy Type";expression={$_.Properties.policyType}}
