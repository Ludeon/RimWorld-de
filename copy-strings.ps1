# Copy original Strings folder to track updates by Ludeon

# Get RW install path
$InstallLocation = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 294100").InstallLocation

# Get DLC folders (including Core)
$dlcs = Get-ChildItem -Directory | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "DefInjected") }

# Enumerate DLC folders (including Core)
foreach ($dlc in $dlcs)
{
  $source = "$InstallLocation\Data\$dlc\Languages\English\Strings"
  if (Test-Path $source) {
    $target = "$dlc\Strings\English"
    Remove-Item -Path $target -Recurse -Force
    Copy-Item -Path $source -Destination $target -Recurse
  }
}
