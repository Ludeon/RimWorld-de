# The output file
$OutputFile = "WordInfo\decline.txt"

# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Paths of the XML files to be scanned for words based on specific regex patterns
$ScanRules = [ordered]@{
  "DefInjected\RoyalTitleDef\*" = "\w+\.label(Female)?"
  "DefInjected\PreceptDef\Precepts_Role.xml" = "\w+\.label"
  "DefInjected\PawnKindDef\*" = ".+\.label(Male|Female)?"
  "DefInjected\MonolithLevelDef\*" = "\w+\.monolithLabel"
  "DefInjected\BodyDef\*, DefInjected\BodyPartDef\*" = ".+\.(label|customLabel)"
  "DefInjected\ThingDef\*" = "\w+\.(tools\.\w+\.)?label"
  "DefInjected\FactionDef\*" = "\w+\.(pawnSingular|leaderTitle(Female)?)"
  "DefInjected\HediffDef\*" = "\w+\.label"
  "DefInjected\PawnRelationDef\*" = "\w+\.label(Female)?"
  "DefInjected\SitePartDef\*" = "\w+\.label"
  "DefInjected\PlanetLayerDef\*" = "\w+\.label"
  "DefInjected\MapGeneratorDef\*" = "\w+\.label"
  "DefInjected\WeatherDef\*" = "\w+\.label"
  "DefInjected\BackstoryDef\*" = "\w+\.title(Female)?"
  "DefInjected\GameConditionDef\*" = "\w+\.label"
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
  -Description "Singular declension (indefinite and definite)" `
  -ExampleFile ([IO.Path]::GetFileNameWithoutExtension($OutputFile)) `
  -ExampleColName $ColNames[1]

Update-OutputFile `
  -OutputFile $OutputFile `
  -ScanRules $ScanRules `
  -ColNames $ColNames `
  -CommentBlock $CommentBlock
