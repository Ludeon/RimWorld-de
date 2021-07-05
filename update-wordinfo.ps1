# Update WordInfo

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Create a temporary folder
$temp = New-Item "$env:temp\$([GUID]::NewGuid())" -ItemType "Directory"

# Create WordInfo/Gender folder
$main = New-Item "Core/WordInfo/Gender" -ItemType "Directory" -Force

# Paths of the XML files in which the words should be searched
$paths = @(
"*\DefInjected\PawnKindDef"
"*\DefInjected\FactionDef"
"*\DefInjected\ThingDef"
"*\DefInjected\WorldObjectDef"
"*\DefInjected\GameConditionDef"
"*\Backstories"
)

# Search words in the XML files and save them in different lists of words depending on their gender
foreach ($path in $paths)
{
  # unknown gender
  Get-Content -Path "$path/*" -Filter "*.xml" | Select-String -Pattern "<(.*(\.label|\.pawnSingular|title|titleShort|\.chargeNoun))>(.*?)</\1>" -All | ForEach-Object { $_.matches.groups[3].value.toLower() } >> "$temp/all_unknown.txt"

  # male gender
  Get-Content -Path "$path/*" -Filter "*.xml" | Select-String -Pattern "<(.*(labelMale))>(.*?)</\1>" -All | ForEach-Object { $_.matches.groups[3].value.toLower() } >> "$temp/all_males.txt"

  # female gender
  Get-Content -Path "$path/*" -Filter "*.xml" | Select-String -Pattern "<(.*(\.labelFemale|titleFemale|titleShortFemale))>(.*?)</\1>" -All | ForEach-Object { $_.matches.groups[3].value.toLower() } >> "$temp/all_females.txt"
}

# Save a list of all found words
Get-Content "$temp/all*.txt" | Sort-Object -Unique | Set-Content "$temp/all.txt"

# Create files
foreach ($fileName in "Male", "Female", "Neuter", "Other", "new_words")
{
  if (!(test-path "$main/$fileName.txt"))
  {
    New-Item -Path $main -Name "$fileName.txt"
  }
}

# Merge found male words into the list of male words
Get-Content "$temp/all_males.txt", "$main/Male.txt" | Sort-Object -Unique | Set-Content "$main/Male.txt"

# Merge found female words into the list of female words
Get-Content "$temp/all_females.txt", "$main/Female.txt" | Sort-Object -Unique | Set-Content "$main/Female.txt"

# Sort the list of neuter words
Get-Content "$main/Neuter.txt" | Sort-Object -Unique | Set-Content "$main/Neuter.txt"

# Sort the list of other words
Get-Content "$main/Other.txt" | Sort-Object -Unique | Set-Content "$main/Other.txt"

# Save a list of words already classified
Get-Content (Get-ChildItem -Path "$main/*" -Include "Male.txt", "Female.txt", "Neuter.txt", "Other.txt") | Sort-Object -Unique | Set-Content "$temp/wordinfo.txt"

# Save a list of words not classified
$objects = @{
  ReferenceObject  = (Get-Content -Path "$temp/wordinfo.txt")
  DifferenceObject = (Get-Content -Path "$temp/all.txt")
}
if ($objects.ReferenceObject -and $objects.DifferenceObject)
{
  Compare-Object @objects -PassThru | Where-Object { $_.SideIndicator -eq "=>" } > "$main/new_words.txt"
}

# Removes obsolete words from the lists
foreach ($gender in "Male", "Female", "Neuter", "Other")
{
  $objects = @{
    ReferenceObject  = (Get-Content -Path "$temp/all.txt")
    DifferenceObject = (Get-Content -Path "$main/$gender.txt")
  }
  if ($objects.ReferenceObject -and $objects.DifferenceObject)
  {
    Compare-Object @objects -IncludeEqual -ExcludeDifferent -PassThru > "$main/$gender.txt"
  }
}

# Delete the temporary folder
Remove-Item -Recurse $temp
