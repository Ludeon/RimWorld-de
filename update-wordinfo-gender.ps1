# Update WordInfo\Gender\*

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Get DLC folders (including Core)
$dlcs = Get-ChildItem -Directory | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "DefInjected") }

# Paths of the XML files in which the words should be searched
$paths = @(
"DefInjected\BackstoryDef"
"DefInjected\BodyDef"
"DefInjected\BodyPartDef"
"DefInjected\ChemicalDef"
"DefInjected\FactionDef"
"DefInjected\GameConditionDef"
"DefInjected\HediffDef"
"DefInjected\PawnKindDef"
"DefInjected\RoyalTitleDef"
"DefInjected\TerrainDef"
"DefInjected\ThingDef"
"DefInjected\TraderKindDef"
"DefInjected\WorldObjectDef"
"DefInjected\RitualBehaviorDef"
"DefInjected\PsychicRitualRoleDef"
"DefInjected\MapGeneratorDef"
"DefInjected\PlanetLayerDef"
)

# Enumerate DLC folders (including Core)
foreach ($dlc in $dlcs)
{
  # Create a temporary folder
  $temp = New-Item "$env:temp\$([GUID]::NewGuid())" -ItemType "Directory"

  # Create WordInfo\Gender folder
  $main = New-Item "$dlc\WordInfo\Gender" -ItemType "Directory" -Force

  # Search words in the XML files
  foreach ($path in $paths)
  {
    if (!(test-path "$dlc\$path"))
    {
      continue
    }
    Get-Content -Path "$dlc\$path\*" -Filter "*.xml" | Select-String -Pattern "<(((?!\b(stages|verbs)\b).)*(\.label|\.labelNoLocation|\.pawnSingular|title|titleFemale|\.chargeNoun|\.customLabel|\.labelMale|\.labelFemale))>(?<value>.*?)</\1>" -All | ForEach-Object { $_.matches[0].groups["value"].value.toLower() } >> "$temp\all.txt"
  }

  # Sort the list of all found words
  Get-Content "$temp\all.txt" | Sort-Object -Unique | Set-Content "$temp\all.txt"

  # Create files
  foreach ($fileName in "Male", "Female", "Neuter", "Other", "new_words")
  {
    if (!(test-path "$main\$fileName.txt"))
    {
      New-Item -Path $main -Name "$fileName.txt"
    }
  }

  # Sort the list of male words
  Get-Content "$main\Male.txt" | Sort-Object -Unique | Set-Content "$main\Male.txt"

  # Sort the list of female words
  Get-Content "$main\Female.txt" | Sort-Object -Unique | Set-Content "$main\Female.txt"

  # Sort the list of neuter words
  Get-Content "$main\Neuter.txt" | Sort-Object -Unique | Set-Content "$main\Neuter.txt"

  # Sort the list of other words
  Get-Content "$main\Other.txt" | Sort-Object -Unique | Set-Content "$main\Other.txt"

  # Save a list of words already classified
  Get-Content (Get-ChildItem -Path "$main\*" -Include "Male.txt", "Female.txt", "Neuter.txt", "Other.txt") | Sort-Object -Unique | Set-Content (New-Item -Path $temp -Name "wordinfo.txt")

  # Save a list of words not classified
  $objects = @{
    ReferenceObject  = (Get-Content -Path "$temp\wordinfo.txt")
    DifferenceObject = (Get-Content -Path "$temp\all.txt")
  }
  if ($objects.ReferenceObject -and $objects.DifferenceObject)
  {
    Compare-Object @objects -PassThru | Where-Object { $_.SideIndicator -eq "=>" } > "$main\new_words.txt"
  }
  else
  {
    Set-Content -Path "$main\new_words.txt" -Value $objects.DifferenceObject
  }

  # Removes obsolete words from the lists
  foreach ($gender in "Male", "Female", "Neuter", "Other")
  {
    $objects = @{
      ReferenceObject  = (Get-Content -Path "$temp\all.txt")
      DifferenceObject = (Get-Content -Path "$main\$gender.txt")
    }
    if ($objects.ReferenceObject -and $objects.DifferenceObject)
    {
      Compare-Object @objects -IncludeEqual -ExcludeDifferent -PassThru > "$main\$gender.txt"
    }
  }

  # Delete the temporary folder
  Remove-Item -Recurse $temp
}
