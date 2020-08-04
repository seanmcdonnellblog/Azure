# Creates an empty hastable
$policy = @()

# Gets all definition
$policies = Get-AzPolicyDefinition -Builtin
$category = "Backup"
$polizy = $policies | Where{$_.properties.metadata.category -eq $category}

# Populates the hashtable with custom fields
$policy+=$polizy | select @{Name="display Name";expression={$_.Properties.displayName}},`
                     @{Name="Policy ID";expression={$_.Name}},`
                     @{Name="Policy Type";expression={$_.Properties.policyType}},`
                     @{Name="Description";expression={$_.Properties.description}},`
                     @{Name="Category";expression={$_.Properties.metadata.category}}

$policy | FL 

########################################################################################################

# Creates an empty hastable
$policy = @()

# Gets all definition
$policies = Get-AzPolicyDefinition -Builtin
$polizy = $policies 

# Populates the hashtable with custom fields
$policy+=$polizy | select @{Name="display Name";expression={$_.Properties.displayName}},`
                     @{Name="Policy ID";expression={$_.Name}},`
                     @{Name="Policy Type";expression={$_.Properties.policyType}},`
                     @{Name="Description";expression={$_.Properties.description}},`
                     @{Name="Category";expression={$_.Properties.metadata.category}}
