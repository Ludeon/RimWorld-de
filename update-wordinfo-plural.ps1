# Update WordInfo\plural.txt

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Get the DLC folders (including Core)
$dlcs = Get-ChildItem -Directory | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "DefInjected") }

# Paths of the XML files in which the words should be searched
# and the regex pattern to match the elements
$items = [ordered]@{
"DefInjected\FactionDef\*" = ".+\.pawnSingular"
"DefInjected\OrderedTakeGroupDef\*" = ".+\.label" # MaxPickUpAllowed
"DefInjected\PawnKindDef\PawnKinds_Empire.xml" = ".+\.label"
"DefInjected\PawnKindDef\PawnKinds_Tribal.xml" = ".+\.label"
"DefInjected\PsychicRitualRoleDef\*" = ".+\.label"
"DefInjected\RitualBehaviorDef\*" = ".+\.label" # MessageLordJobNeedsAtLeastNumRolePawn
"DefInjected\ThingDef\Apparel_*.xml, DefInjected\ThingDef\RangedSpecial.xml, DefInjected\ThingDef\Weapons_Ranged.xml" = ".+\.chargeNoun"
"DefInjected\ThingDef\Buildings_Furniture.xml" = "Blackboard\.label" # StatsReport_Connected
"DefInjected\ThingDef\Buildings_Mech*" = "\w+\.label"
"DefInjected\ThingDef\Buildings_Misc.xml" = "TransportPod\.label" # LoadTransporters
"DefInjected\ThingDef\Items_Resource_Manufactured.xml" = "Wastepack\.label" # CommandAutoLoad, CommandEjectContents, ThingsProduced
"DefInjected\ThingDef\Plants_*" = ".+\.label" # MessagePlantIncompatibleWithRoof
"DefInjected\ThingDef\Races_Mechanoids_Light.xml" = "Mech_WarUrchin\.label"
"DefInjected\ThingDef\Various_Stone.xml" = "Chunk\w+\.label" # DeepDrillExhausted
"Keyed\FloatMenu.xml" = "Deity" # DeitiesRequired
}

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
$tempFile = New-Item "$env:temp\$([GUID]::NewGuid()).txt"
foreach ($dlc in $dlcs)
{
  Clear-Content -Path $tempFile
  Set-Location -Path "$PSScriptRoot\$dlc"
  $pluralFile = "WordInfo\plural.txt"

  # Create a hash table of singular nominative words
  $HashTable = @{}
  $pluralFileLines = @()
  if (test-path $pluralFile) {
    $pluralFileLines = Get-Content -Path $pluralFile
    Remove-Item $pluralFile
  }
  foreach ($line in ($pluralFileLines | ConvertFrom-Csv -Delimiter ";" -Header $header))
  {
    if ($line.KEY.substring(0, 2) -eq "//") { continue } # skip "//" comments
    $fields = $line.PSObject.Properties.Value -join ";"
    $fields = $fields -replace "(?<=;);" # remove empty fields for clarity and reducing file size
    $HashTable[$line.KEY] = $fields
  }

  # Search words in the XML files and add them to a temp file
  $items.GetEnumerator() | ForEach-Object {
    $paths = ($($_.Key) -split ',').Trim()
    $pattern = $($_.Value)
    $elements = @()
    $ps = @()
    foreach ($path in $paths) {
      if (!(test-path $path)) { continue } # skip non-existing paths
      $ps += $path
      $elements += Get-Content -Path $path -Filter "*.xml" | Select-String -Pattern "<($pattern)>(?<value>.*?)</\1>" -All
    }
    if ($elements.Count -eq 0) { return } # skip if no elements found
    "// $($ps -join ', ') ($pattern)" >> $tempFile # categorize plural.txt by paths
    # enumerate lines
    $tempFileLines = @()
    foreach ($element in $elements) { $tempFileLines += $element.matches[0].groups["value"] }
    Add-Content -Path $tempFile -Value ($tempFileLines | Sort-Object)
  }

  # Merge the temp file with plural.txt
  $tempFileLines = Get-Content $tempFile
  if ($tempFileLines.Count -eq 0) { continue } # skip if temp file is empty
  $pluralFileLines = @($header -join ";")
  $pluralFileLines += $comments
  foreach ($line in ($tempFileLines | Select-Object -Unique))
  {
    if ($line.substring(0, 2) -eq "//") {
      $pluralFileLines += $line
    } elseif ($HashTable.ContainsKey($line)) {
      $pluralFileLines += $HashTable[$line]
    } else {
      $pluralFileLines += $line + ";"
    }
  }
  New-Item $pluralFile -Force | Out-Null
  Set-Content -Path $pluralFile -Value $pluralFileLines
}
Set-Location -Path $PSScriptRoot
Remove-Item $tempFile
