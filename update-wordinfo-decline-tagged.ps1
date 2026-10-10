# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Paths of the XML files to be scanned for words based on specific regex patterns
$ScanRules = [ordered]@{
  "DefInjected\PawnKindDef\*" = ".+\.label(Male|Female)?"
}

$ColNames = @(
  "KEY"
  "REPLACEMENT"
)

$Cases = @(
  # case name     # male articles    # female articles  # neuter articles  # maps   # key format
  @("nominative", @("ein", "der"),   @("eine", "die"),  @("ein", "das"),   @(0, 4), "{0}"),
  @("genitive",   @("eines", "des"), @("einer", "der"), @("eines", "des"), @(1, 5), "von {0}"),
  @("dative",     @("einem", "dem"), @("einer", "der"), @("einem", "dem"), @(2, 6), "{0}"),
  @("accusative", @("einen", "den"), @("eine", "die"),  @("ein", "das"),   @(3, 7), "{0}")
)

$ArticlesNom = @{"M" = $Cases[0][1]; "F" = $Cases[0][2]; "N" = $Cases[0][3]}

$TagFormat = "<color=#D09B61FF>{0}</color>"

$Cache = @{}

foreach ($Case in $Cases) {
  $CaseNameFull = $Case[0]
  $CaseNameShort = $CaseNameFull.Substring(0, 3)
  $Articles = @{"M" = $Case[1]; "F" = $Case[2]; "N" = $Case[3]}
  $Maps = $Case[4]
  $KeyFormat = $Case[5]
  $OutputFile = "WordInfo\decline_tagged_$CaseNameShort.txt"

  $CommentBlock = New-CommentBlock `
    -ScriptFile $($MyInvocation.MyCommand.Name) `
    -Description "Log text improvements ($CaseNameFull)" `
    -ExampleFile ([IO.Path]::GetFileNameWithoutExtension($OutputFile)) `
    -ExampleColName $ColNames[1]

  Update-OutputFile `
    -OutputFile $OutputFile `
    -ScanRules $ScanRules `
    -ColNames $ColNames `
    -CommentBlock $CommentBlock `
    -PostProcCallback {
      param($Lines, $DLC)
      if (-not $Cache[$DLC]) { $Cache[$DLC] = @{} }
      $DeclineFile = "WordInfo\decline.txt"
      if (-not (Test-Path $DeclineFile)) { return }
      if (-not $Cache[$DLC].DeclineLookup) {
        $Cache[$DLC].DeclineLookup = New-HashTable -Lines (Get-Content -Path $DeclineFile)
      }
      if (-not $Cache[$DLC].GenderLookup) {
        $Cache[$DLC].GenderLookup = @{}
        foreach ($Gender in "Male", "Female", "Neuter") {
          $GenderShort = $Gender[0].ToString()
          foreach ($Word in Get-Content "WordInfo\Gender\$Gender.txt") {
            $Cache[$DLC].GenderLookup[$Word] = $GenderShort
          }
        }
      }
      $NewLines = @()
      foreach ($Line in $Lines) {
        if (Test-Comment $Line) {
          $NewLines += $Line -Join ";"
          continue
        }
        $DeclineLine = $Cache[$DLC].DeclineLookup[$Line]
        if (-not $DeclineLine) {
          $NewLines += "// ${Line}: No declension data found"
          continue
        }
        $DeclineLineFields = $DeclineLine -Split ";"
        $NOM = $DeclineLineFields[0]
        $Gender = $Cache[$DLC].GenderLookup[$NOM]
        if ($Gender) {
          for ($i = 0; $i -lt $Articles[$Gender].Count; $i++) {
            $Article = $Articles[$Gender][$i]
            $Key = $KeyFormat -f $TagFormat -f "$($ArticlesNom[$Gender][$i]) $NOM"
            $DeclineLineField = $DeclineLineFields[$Maps[$i]]
            $Field = if ($DeclineLineField) { $DeclineLineField } else { $NOM }
            $Replacement = $TagFormat -f "$Article $Field"
            if ($Key -ne $Replacement) { $NewLines += "$Key;$Replacement" }
            if ($NOM -ne $Field) { $NewLines += "$($TagFormat -f $NOM);$($TagFormat -f $Field)" }
          }
        } else {
          $NewLines += "// ${NOM}: No gender data found"
        }
      }
      return $NewLines
    }
}
