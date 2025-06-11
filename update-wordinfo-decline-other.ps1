# Update WordInfo\decline_other.txt

$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Get the DLC folders (including Core)
$dlcs = Get-ChildItem -Directory | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "DefInjected") }

# Paths of the XML files in which the words should be searched
# and the regex pattern to match the elements
$items = [ordered]@{
"DefInjected\FactionDef\*" = "\w+\.pawnsPlural"
}

# Header line for decline_other.txt
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
// Declension for special cases
// Usage syntax: {lookup: TEXT; FILE_NO_EXT; INDEX}
// TEXT is the key to access a row.
// FILE_NO_EXT is the file in which TEXT should be looked up. Omit the extension.
// INDEX determines the column to be used. Can be omitted if you need index 1.
// For example, {lookup: {0}; decline_other; 2} looks up 2_DAT.
// ---
"@

# Enumerate DLC folders (including Core)
$tempFile = New-Item "$env:temp\$([GUID]::NewGuid()).txt"
foreach ($dlc in $dlcs)
{
  Clear-Content -Path $tempFile
  Set-Location -Path "$PSScriptRoot\$dlc"
  $declineFile = "WordInfo\decline_other.txt"

  # Create a hash table of nominative words
  $HashTable = new-object System.Collections.Hashtable
  $declineFileLines = @()
  if (test-path $declineFile) {
    $declineFileLines = Get-Content -Path $declineFile
    Remove-Item $declineFile
  }
  foreach ($line in ($declineFileLines | ConvertFrom-Csv -Delimiter ";" -Header $header))
  {
    if ($line.NOM.substring(0, 2) -eq "//") { continue } # skip "//" comments
    $fields = $line.PSObject.Properties.Value -join ";"
    $fields = $fields -replace "(?<=;);" # remove empty fields for clarity and reducing file size
    $HashTable[$line.NOM] = $fields
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
    "// $($ps -join ', ') ($pattern)" >> $tempFile # categorize decline_other.txt by paths
    # enumerate lines
    $tempFileLines = @()
    foreach ($element in $elements) { $tempFileLines += $element.matches[0].groups["value"] }
    Add-Content -Path $tempFile -Value ($tempFileLines | Sort-Object)
  }

  # Merge the temp file with decline_other.txt
  $tempFileLines = Get-Content $tempFile
  if ($tempFileLines.Count -eq 0) { continue } # skip if temp file is empty
  $declineFileLines = @($header -join ";")
  $declineFileLines += $comments
  foreach ($line in ($tempFileLines | Select-Object -Unique))
  {
    if ($line.substring(0, 2) -eq "//") {
      $declineFileLines += $line
    } elseif ($HashTable.ContainsKey($line)) {
      $declineFileLines += $HashTable[$line]
    } else {
      $declineFileLines += $line + ";"
    }
  }
  New-Item $declineFile -Force | Out-Null
  Set-Content -Path $declineFile -Value $declineFileLines
}
Set-Location -Path $PSScriptRoot
Remove-Item $tempFile
