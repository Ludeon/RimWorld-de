# Copy original Strings folder to track updates by Ludeon

# Include shared helper functions
. "$PSScriptRoot\utils.ps1"

# Get RW install path
$InstallLocation = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 294100").InstallLocation

# Enumerate DLC folders (including Core)
foreach ($DLC in Get-DLCs) {
  $Source = "$InstallLocation\Data\$DLC\Languages\English\Strings"
  if (Test-Path $Source) {
    $Target = "$DLC\Strings\English"
    Remove-Item -Path $Target -Recurse -Force
    Copy-Item -Path $Source -Destination $Target -Recurse
  }
}
