# The Gender folder and its files
$GenderFolder = "WordInfo\Gender"
$GenderFiles = @("Male", "Female", "Neuter", "Other") | % { "$GenderFolder\$_.txt" }
$NewWordsFile = "$GenderFolder\new_words.txt"

# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# XML folders to scan
$Folders = @(
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

# Regex pattern to find the words
$Pattern = "<(((?!\b(stages|verbs)\b).)*(\.label|\.labelNoLocation|\.pawnSingular|title|titleFemale|\.chargeNoun|\.customLabel|\.labelMale|\.labelFemale))>(?<value>.*?)</\1>"

# Enumerate DLC folders (including Core)
foreach ($DLC in Get-DLCs) {
  Set-Location "$PSScriptRoot\$DLC"
  # Ensure Gender folder exists
  if (!(Test-Path $GenderFolder)) {
    New-Item -ItemType Directory -Path $GenderFolder | Out-Null
  }
  # Collect all XML words
  $AllWords = @()
  foreach ($Folder in $Folders) {
    if (!(Test-Path $Folder)) { continue }
    $XMLFiles = Get-ChildItem -Path $Folder -Filter "*.xml"
    foreach ($File in $XMLFiles) {
      $Matches = Select-String -Path $File.FullName -Pattern $Pattern -AllMatches
      foreach ($Match in $Matches) {
        $AllWords += $Match.Matches[0].Groups["value"].Value.ToLower()
      }
    }
  }
  # Normalize + sort + unique
  $AllWords = $AllWords | Sort-Object -Unique
  # Ensure gender files exist
  foreach ($File in ($GenderFiles + $NewWordsFile)) {
    if (!(Test-Path $File)) {
      New-Item -ItemType File -Path $File | Out-Null
    }
  }
   # Build list of already classified words + sort
  $Classified = @()
  foreach ($File in $GenderFiles) {
    $Content = Get-Content $File
    $Content | Sort-Object -Unique | Set-Content $File
    $Classified += $Content
  }
  $Classified = $Classified | Sort-Object -Unique
  # Determine new words
  $NewWords = Compare-Object -ReferenceObject $Classified -DifferenceObject $AllWords -PassThru | Where-Object { $_.SideIndicator -eq "=>" }
  $NewWords | Sort-Object -Unique | Set-Content $NewWordsFile
  # Remove obsolete words from gender lists
  foreach ($File in $GenderFiles) {
    $Words = Get-Content $File
    $Valid = Compare-Object -ReferenceObject $AllWords -DifferenceObject $Words -IncludeEqual -ExcludeDifferent -PassThru
    $Valid | Sort-Object -Unique | Set-Content $File
  }
}
Set-Location $PSScriptRoot
