# The output file
$OutputFile = "WordInfo\capacity.txt"

# Force all cmdlets to use UTF‑8 encoding
$PSDefaultParameterValues["*:Encoding"] = "UTF8"

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Paths of the XML files to be scanned for words based on specific regex patterns
$ScanRules = [ordered]@{
  "DefInjected\PawnCapacityDef\*" = "\w+\.label.*?"
}

$Formats = @(
  "unfähig für {0}" # IncapableOfCapacity, AbilityDisabledNoCapacity, CannotMissingHealthActivities, RequiredCapacity
  "Körperfunktion '{0}'" # KilledCapacity tale
)

$ColNames = @(
  "KEY"   # key, normal capacity label
  "1_OUT" # index #1, other outcome
)

$CommentBlock = New-CommentBlock `
  -ScriptFile $($MyInvocation.MyCommand.Name) `
  -Description "Capacity text improvements" `
  -ExampleFile ([IO.Path]::GetFileNameWithoutExtension($OutputFile)) `
  -ExampleColName $ColNames[1]

Update-OutputFile `
  -OutputFile $OutputFile `
  -ScanRules $ScanRules `
  -Formats $Formats `
  -ColNames $ColNames `
  -CommentBlock $CommentBlock
