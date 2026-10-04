# The output file
$OutputFile = "WordInfo\decline_tagged.txt"

# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Paths of the XML files to be scanned for words based on specific regex patterns
$ScanRules = [ordered]@{
  "DefInjected\PawnKindDef\*" = ".+\.label(Male|Female)?"
}

$ColNames = @(
  "KEY"     # key
  "1_NOM"   # index #1, nominative case
  "2_GEN"   # index #2, genitive case
  "3_DAT"   # index #3, dative case
  "4_ACC"   # index #4, accusative case
)

$CommentBlock = New-CommentBlock `
  -ScriptFile $($MyInvocation.MyCommand.Name) `
  -Description "Log text improvements" `
  -ExampleFile ([IO.Path]::GetFileNameWithoutExtension($OutputFile)) `
  -ExampleColName $ColNames[1]

Update-OutputFile `
  -OutputFile $OutputFile `
  -ScanRules $ScanRules `
  -ColNames $ColNames `
  -CommentBlock $CommentBlock `
  -PostProcCallback {
    param($Lines)
    $DeclineFile = "WordInfo\decline.txt"
    if (!(Test-Path $DeclineFile)) { return }
    $WordsMal = Get-Content "WordInfo\Gender\Male.txt"
    $WordsFem = Get-Content "WordInfo\Gender\Female.txt"
    $WordsNeu = Get-Content "WordInfo\Gender\Neuter.txt"
    $ArticlesMal = @{
      Indef = @("ein", "eines", "einem", "einen")
      Def = @("der", "des", "dem", "den")
    }
    $ArticlesFem = @{
      Indef = @("eine", "einer", "einer", "eine")
      Def = @("die", "der", "der", "die")
    }
    $ArticlesNeu = @{
      Indef = @("ein", "eines", "einem", "ein")
      Def = @("das", "des", "dem", "das")
    }
    $ArticlesDeclineMap = @{
      Indef = @(0, 1, 2, 3)
      Def = @(4, 5, 6, 7)
    }
    $NewLines = @()
    $DeclineLines = Get-Content -Path $DeclineFile
    $HashTable = New-HashTable -Lines $DeclineLines
    foreach ($Line in $Lines) {
      if (Test-Comment $Line) {
        $NewLines += $Line -Join ";"
        continue
      }
      $DeclineLine = $HashTable[$Line]
      if (-not $DeclineLine) {
        $NewLines += "// ${Line}: No declension data found"
        continue
      }
      $DeclineLineFields = $DeclineLine -Split ";"
      $NOM = $DeclineLineFields[0]
      $CurrentArticles = switch ($NOM) {
        { $_ -in $WordsMal } { $ArticlesMal; break }
        { $_ -in $WordsFem } { $ArticlesFem; break }
        { $_ -in $WordsNeu } { $ArticlesNeu; break }
      }
      if ($CurrentArticles) {
        foreach ($Articles in $CurrentArticles.GetEnumerator()) {
          $NewFields = @("<color=#D09B61FF>$($Articles.Value[0]) $NOM</color>")
          $NewFields += for ($i = 0; $i -lt $Articles.Value.Count; $i++) {
            $Article = $Articles.Value[$i]
            $DeclineLineField = $DeclineLineFields[$ArticlesDeclineMap[$Articles.Key][$i]]
            $Field = if ($DeclineLineField) { $DeclineLineField } else { $NOM }
            "<color=#D09B61FF>$Article $Field</color>"
          }
          $NewLines += $NewFields -Join ";"
        }
      } else {
        $NewLines += "// ${NOM}: No gender data found"
      }
    }
    return $NewLines
  }
