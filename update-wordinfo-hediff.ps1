# The output file
$OutputFile = "WordInfo\hediff.txt"

# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Paths of the XML files to be scanned for words based on specific regex patterns
$ScanRules = [ordered]@{
  "DefInjected\HediffDef\*" = "\w+\.labelNoun"
}

$Formats = @(
  "von {0}" # Transition_DiedInclude, Transition_Downed
)

$ColNames = @(
  "KEY"   # key
  "1_OUT" # index #1, other outcome
)

$CommentBlock = New-CommentBlock `
  -ScriptFile $($MyInvocation.MyCommand.Name) `
  -Description "[CULPRITHEDIFF_labelNoun] improvements" `
  -ExampleFile ([IO.Path]::GetFileNameWithoutExtension($OutputFile)) `
  -ExampleColName $ColNames[1]

Update-OutputFile `
  -OutputFile $OutputFile `
  -ScanRules $ScanRules `
  -Formats $Formats `
  -ColNames $ColNames `
  -CommentBlock $CommentBlock
