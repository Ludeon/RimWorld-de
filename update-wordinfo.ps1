# Search for all scripts in the current directory that start with "update-wordinfo-" and end with ".ps1"
$scripts = Get-ChildItem -Filter "update-wordinfo-*.ps1" | Sort-Object Name

# Run each found script sequentially
foreach ($script in $scripts) {
    Write-Host "Running $($script.Name)"
    & ".\$($script.Name)"
}
