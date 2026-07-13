# The output file
$OutputFile = "WordInfo\compound.txt"

# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Paths of the XML files to be scanned for words based on specific regex patterns
$ScanRules = [ordered]@{
  "DefInjected\FactionDef\*" = "\w+\.pawnSingular"
  "DefInjected\ThingDef\Plants_*" = "\w+\.label"
  "DefInjected\*\Races_*" = "\w+\.label" # Hospitality_Animals, MeatLabel
}

$ColNames = @(
  "NOM"       # key, nominative
  "1_COM_PRE" # index #1, compound prefix
)

$CommentBlock = New-CommentBlock `
  -ScriptFile $($MyInvocation.MyCommand.Name) `
  -Description "Compound words (as prefix), e.g. Piraten in Piratengruppe" `
  -ExampleFile ([IO.Path]::GetFileNameWithoutExtension($OutputFile)) `
  -ExampleColName $ColNames[1]

Update-OutputFile `
  -OutputFile $OutputFile `
  -ScanRules $ScanRules `
  -ColNames $ColNames `
  -CommentBlock $CommentBlock
