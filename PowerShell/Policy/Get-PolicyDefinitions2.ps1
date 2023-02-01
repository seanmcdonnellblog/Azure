$policies = Get-AzPolicyDefinition -Builtin
$categories = ($policies.Properties.metadata.category | Sort-Unique)

Foreach ($category in $categories) {
    $polizy = $policies | Where-Object { $_.properties.metadata.category -eq $category }
    $policy = $polizy | Select-Object 'Display Name' = $_.Properties.displayName,
                                      'Allowed Values' = [string]::Join(', ', ($_.Properties.Parameters.effect.allowedValues.split(' '))),
                                      'Description' = $_.Properties.description,
                                      'Policy ID' = $_.Name,
                                      'Policy Type' = $_.Properties.policyType,
                                      'Category' = $_.Properties.metadata.category
    $policy | Export-Excel -Path '.\AzurePolicy-Builtin-Policies.xlsx' -AutoSize -TableStyle Medium16 -WorksheetName $category -ConditionalText (
        New-ConditionalText Deprecated DarkRed LightPink,
        New-ConditionalText Preview Blue Cyan
    )
}
