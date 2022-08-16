## Requires Export-Excel Module to be installed
$policy = @()
$categories = @()

# Gets all definition
$policies = Get-AzPolicyDefinition -Builtin
$categories = $policies.Properties.metadata.category | Sort -Unique
Foreach($category in $categories){
    $polizy = $policies | Where{$_.properties.metadata.category -eq $category}

    # Populates the hashtable with custom fields
    $policy+=$polizy | select @{Name="Display Name";expression={$_.Properties.displayName}},`
                     @{Name="Policy ID";expression={$_.Name}},`
                     @{Name="Policy Type";expression={$_.Properties.policyType}},`
                     @{Name="Description";expression={$_.Properties.description}},`
                     @{Name="Category";expression={$_.Properties.metadata.category}}

    $policy | Export-Excel -Path "C:\Temp\AzurePolicy\AzurePolicy-Builtin-initiatives.xlsx" -AutoSize -TableStyle Medium16 -WorksheetName $category -ConditionalText $(
                New-ConditionalText Deprecated DarkRed LightPink
                New-ConditionalText Preview Blue Cyan
            )
    $policy = @()
    $polizy = @()
}
