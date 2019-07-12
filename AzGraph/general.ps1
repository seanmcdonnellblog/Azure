# Display total resources by type
$query = "summarize count() by type | project resource=type , total=count_ | order by total desc"
$allResourceCount = Search-AzGraph -Query $query 
$allResourceCount | FT

# Display total resources by location
$query = "summarize count() by location | project total=count_, location | order by total desc"
$allResourceCount = Search-AzGraph -Query $query 
$allResourceCount | FT
