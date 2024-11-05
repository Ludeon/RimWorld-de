# Update WordInfo\decline.txt

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Get the DLC folders (including Core)
$dlcs = Get-ChildItem -Directory | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "DefInjected") }

# Paths of the XML files in which the words should be searched
$paths = @(
"RoyalTitleDef\*"
"PreceptDef\Precepts_Role.xml"
"PawnKindDef\*"
"MonolithLevelDef\*"
"ThingDef\*"
"FactionDef\*"
"HediffDef\*"
"PawnRelationDef\*"
"SitePartDef\*"
"WeatherDef\*"
)

# Header line for decline.txt
$header = @(
"NOM"       # key, indefinite nominative case
"1_GEN"     # index #1, indefinite genitive case
"2_DAT"     # index #2, indefinite dative case
"3_ACC"     # index #3, indefinite accusative case
"4_NOM_DEF" # index #4, definite nominative case
"5_GEN_DEF" # index #5, definite genitive case
"6_DAT_DEF" # index #6, definite dative case
"7_ACC_DEF" # index #7, definite accusative case
"8_CON"     # index #8, conjunction
)

# Usage description. Using comment flag "//" instead of the recommended "#" as RW doesn't support it.
$comments = @"
// Singular declension (indefinite and definite)
// Usage syntax: {lookup: TEXT; FILE_NO_EXT; INDEX}
// TEXT is the key to access a row.
// FILE_NO_EXT is the file in which TEXT should be looked up. Omit the extension.
// INDEX determines the column to be used. Can be omitted if you need index 1.
// For example, {lookup: {0}; decline; 2} looks up 2_DAT.
// ---
"@

# Enumerate DLC folders (including Core)
foreach ($dlc in $dlcs)
{
  # Create a temporary folder
  $temp = New-Item "$env:temp\$([GUID]::NewGuid())" -ItemType "Directory"

  # Create WordInfo folder
  $WordInfoFolder = New-Item "$dlc\WordInfo" -ItemType "Directory" -Force

  # Create decline.txt file
  if (!(test-path "$WordInfoFolder\decline.txt"))
  {
    New-Item "$WordInfoFolder\decline.txt" -Value "$($header -join ";")`n$comments`n" | Out-Null
  }

  # Read decline.txt content
  $declineFile = Get-Content -Path "$WordInfoFolder\decline.txt"

  # Create a hash table of indefinite nominative words
  $HashTable = @{}
  foreach ($r in ($declineFile | ConvertFrom-Csv -Delimiter ";" -Header $header))
  {
    if ($r.NOM.substring(0, 2) -eq "//") { continue } # skip "//" comments
    $fields = $r.PSObject.Properties.Value -join ";"
    $fields = $fields -replace "(?<=;);" # remove empty fields for clarity and reducing file size
    $HashTable[$r.NOM] = $fields
  }

  # Search words in the XML files and add them to a temp file
  foreach ($path in $paths)
  {
    $path = "$dlc\DefInjected\$path"
    if (!(test-path "$path")) { continue } # skip non-existing paths
    $elements = Get-Content -Path "$path" -Filter "*.xml" | Select-String -Pattern "<(((?!\b(stages|verbs)\b).)*(\.label|\.labelNoLocation|\.pawnSingular|\.chargeNoun|\.customLabel|\.labelMale|\.labelFemale|\.monolithLabel))>(?<value>.*?)</\1>" -All
    "// $path" >> "$temp\all.txt" # categorize decline.txt by paths
    # enumerate lines
    $lines = @()
    foreach ($element in $elements) { $lines += $element.matches[0].groups["value"] }
    Add-Content -Path "$temp\all.txt" -Value ($lines | Sort-Object)
  }

  # Merge the temp file with decline.txt
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

  # Add the merged content to decline.txt
  Set-Content -Path "$WordInfoFolder\decline.txt" -Value $lines

  # Delete the temporary folder
  Remove-Item -Recurse $temp
}
