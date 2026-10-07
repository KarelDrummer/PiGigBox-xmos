<#
.SYNOPSIS
  Imports the XMOS XTC Tools environment (same as an "XTC Tools Command Prompt") into the current PowerShell session.
.DESCRIPTION
  Dot-source it:  . .\scripts\xtc-env.ps1
  Set XTC_VERSION_DIR (e.g. "C:\Program Files\XMOS\XTC\15.3.1") or pass -XtcDir to pick a specific install,
  otherwise the newest one in "$env:ProgramFiles\XMOS\XTC" is used.
  XMOS_CMAKE_PATH comes from the XTC Tools (15.3+ ships XCommon CMake) and overrides any global value.
#>
param([string]$XtcDir = $env:XTC_VERSION_DIR)

if (-not $XtcDir) {
    $root = Join-Path $env:ProgramFiles 'XMOS\XTC'
    $XtcDir = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d+(\.\d+)*$' } |
        Sort-Object { [version]$_.Name } -Descending |
        Select-Object -First 1 -ExpandProperty FullName
}
if (-not $XtcDir -or -not (Test-Path (Join-Path $XtcDir 'SetEnv.bat'))) {
    throw 'XTC Tools not found. Install them from https://www.xmos.com/software-tools or set XTC_VERSION_DIR.'
}

cmd /d /c "`"$XtcDir\SetEnv.bat`" >nul && set" | ForEach-Object {
    if ($_ -match '^([^=]+)=(.*)$') { Set-Item -Path "env:$($Matches[1])" -Value $Matches[2] }
}
$env:XTC_VERSION_DIR = $XtcDir
Write-Host "XTC Tools:       $XtcDir"
Write-Host "XMOS_CMAKE_PATH: $env:XMOS_CMAKE_PATH"