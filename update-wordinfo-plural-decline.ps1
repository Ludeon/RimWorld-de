# The output file
$OutputFile = "WordInfo\plural_decline.txt"

# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Paths of the XML files to be scanned for words based on specific regex patterns
$ScanRules = [ordered]@{
  "DefInjected\FactionDef\*" = "\w+\.pawnsPlural"
  "DefInjected\PawnKindDef\*" = "\w+\.labelPlural"
}

$ColNames = @(
  "NOM"       # key, indefinite nominative case
  "1_GEN"     # index #1, indefinite genitive case
  "2_DAT"     # index #2, indefinite dative case
  "3_ACC"     # index #3, indefinite accusative case
  "4_NOM_DEF" # index #4, definite nominative case
  "5_GEN_DEF" # index #5, definite genitive case
  "6_DAT_DEF" # index #6, definite dative case
  "7_ACC_DEF" # index #7, definite accusative case
)

$CommentBlock = New-CommentBlock `
  -ScriptFile $($MyInvocation.MyCommand.Name) `
  -Description "Plural declension (indefinite and definite)" `
  -ExampleFile ([IO.Path]::GetFileNameWithoutExtension($OutputFile)) `
  -ExampleColName $ColNames[1]

$ExtraLinesProvider = {
  $PluralFile = "WordInfo\plural.txt"
  if (!(Test-Path $PluralFile)) { return }
  $PluralWords = @()
  $Lines = Get-Content -Path $PluralFile | ConvertFrom-Csv -Delimiter ";"
  foreach ($Line in $Lines) {
    if (Test-Comment $Line.SINGULAR) { continue }
    if ($Line.PLURAL) {
      $PluralWords += $Line.PLURAL
    } else {
      $PluralWords += $Line.SINGULAR
    }
  }
  return @("// $PluralFile") + ($PluralWords | Sort-Object)
}

Update-OutputFile `
  -OutputFile $OutputFile `
  -ScanRules $ScanRules `
  -ColNames $ColNames `
  -CommentBlock $CommentBlock `
  -ExtraLinesProvider $ExtraLinesProvider
