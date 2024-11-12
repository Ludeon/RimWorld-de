# Update WordInfo\plural.txt

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Get the DLC folders (including Core)
$dlcs = Get-ChildItem -Directory | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "DefInjected") }

# Paths of the XML files in which the words should be searched
$paths = @(
"FactionDef\*"
"OrderedTakeGroupDef\*"
"PawnKindDef\PawnKinds_Empire.xml"
"PawnKindDef\PawnKinds_Tribal.xml"
"PsychicRitualRoleDef\*"
"RitualBehaviorDef\*"
"ThingDef\Apparel_Packs.xml"
"ThingDef\Apparel_Utility.xml"
"ThingDef\Apparel_Various.xml"
"ThingDef\Buildings_Mech*"
"ThingDef\Buildings_Misc.xml"
"ThingDef\Items_Resource_Manufactured.xml"
"ThingDef\Plants_*"
"ThingDef\Races_Mechanoids_Light.xml"
"ThingDef\RangedSpecial.xml"
"ThingDef\Various_Stone.xml"
"ThingDef\Weapons_Ranged.xml"
)

# Header line for plural.txt
$header = @(
"KEY"       # singular nominative case
"1_NOM"     # index #1, nominative case without article
"2_GEN"     # index #2, genitive case without article
"3_DAT"     # index #3, dative case without article
"4_ACC"     # index #4, accusative case without article
"5_NOM_ART" # index #5, nominative case with article
"6_GEN_ART" # index #6, genitive case with article
"7_DAT_ART" # index #7, dative case with article
"8_ACC_ART" # index #8, accusative case with article
)

# Usage description. Using comment flag "//" instead of the recommended "#" as RW doesn't support it.
$comments = @"
// Plural declension (without and with article)
// NOTE: Ingame pluralization use this file automatically (always index 1).
// Usage syntax: {lookup: TEXT; FILE_NO_EXT; INDEX}
// TEXT is the key to access a row.
// FILE_NO_EXT is the file in which TEXT should be looked up. Omit the extension.
// INDEX determines the column to be used. Can be omitted if you need index 1.
// For example, {lookup: {0}; plural; 2} looks up 2_GEN.
// ---
"@

# Enumerate DLC folders (including Core)
foreach ($dlc in $dlcs)
{
  # Create a temporary folder
  $temp = New-Item "$env:temp\$([GUID]::NewGuid())" -ItemType "Directory"

  # Create WordInfo folder
  $WordInfoFolder = New-Item "$dlc\WordInfo" -ItemType "Directory" -Force

  # Create plural.txt file
  if (!(test-path "$WordInfoFolder\plural.txt"))
  {
    New-Item "$WordInfoFolder\plural.txt" -Value "$($header -join ";")`n$comments`n" | Out-Null
  }

  # Read plural.txt content
  $pluralFile = Get-Content -Path "$WordInfoFolder\plural.txt"

  # Create a hash table of singular nominative words
  $HashTable = @{}
  foreach ($r in ($pluralFile | ConvertFrom-Csv -Delimiter ";" -Header $header))
  {
    if ($r.KEY.substring(0, 2) -eq "//") { continue } # skip "//" comments
    $fields = $r.PSObject.Properties.Value -join ";"
    $fields = $fields -replace "(?<=;);" # remove empty fields for clarity and reducing file size
    $HashTable[$r.KEY] = $fields
  }

  # Search words in the XML files and add them to a temp file
  foreach ($path in $paths)
  {
    $path = "$dlc\DefInjected\$path"
    if (!(test-path "$path")) { continue } # skip non-existing paths
    $elements = Get-Content -Path "$path" -Filter "*.xml" | Select-String -Pattern "<(((?!\b(stages|verbs)\b).)*(\.label|\.labelNoLocation|\.pawnSingular|\.chargeNoun|\.customLabel|\.labelMale|\.labelFemale|\.monolithLabel))>(?<value>.*?)</\1>" -All
    "// $path" >> "$temp\all.txt" # categorize plural.txt by paths
    # enumerate lines
    $lines = @()
    foreach ($element in $elements) { $lines += $element.matches[0].groups["value"] }
    Add-Content -Path "$temp\all.txt" -Value ($lines | Sort-Object)
  }

  # Merge the temp file with plural.txt
  $lines = @($header -join ";")
  $lines += $comments
  foreach ($line in (Get-Content "$temp\all.txt" | Select-Object -Unique))
  {
    if ($line.substring(0, 2) -eq "//") {
      $lines += $line
    } elseif ($HashTable.ContainsKey($line)) {
      $lines += $HashTable[$line]
    } else {
      $lines += $line + ";"
    }
  }

  # Add the merged content to plural.txt
  Set-Content -Path "$WordInfoFolder\plural.txt" -Value $lines

  # Delete the temporary folder
  Remove-Item -Recurse $temp
}
