param(
  [string]$OtClientModules = 'C:\Users\zycie\AppData\Roaming\mklauncher\althea\modules',
  [string]$RepoModulePath = 'C:\dev\CTOmodule\modules\CTOmodule',
  [string]$ModuleName = 'CTOmodule'
)

$target = Join-Path $OtClientModules $ModuleName

if (Test-Path $target) {
  Write-Host 'Target already exists:' $target
  Write-Host 'Rename or remove it first (backup), then re-run.'
  exit 1
}

try {
  New-Item -ItemType SymbolicLink -Path $target -Target $RepoModulePath | Out-Null
  Write-Host 'Symlink created:' $target '->' $RepoModulePath
} catch {
  Write-Host 'New-Item SymbolicLink failed. Trying mklink (may require Admin or Developer Mode)...'
  cmd /c "mklink /D "$target" "$RepoModulePath""
}