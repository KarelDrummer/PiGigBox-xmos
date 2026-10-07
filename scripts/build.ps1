<#
.SYNOPSIS  Builds the PiGigBox application with XCommon CMake (as documented in the XTC Tools guide).
.EXAMPLE   .\scripts\build.ps1
.EXAMPLE   .\scripts\build.ps1 -Clean
#>
param(
    [string]$App = 'sw_pigigbox\app_pigigbox_xk_316_mc',
    [switch]$Clean
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
. (Join-Path $PSScriptRoot 'xtc-env.ps1')

$appDir = Join-Path $repo $App
if ($Clean) {
    Remove-Item (Join-Path $appDir 'build'), (Join-Path $appDir 'bin') -Recurse -Force -ErrorAction SilentlyContinue
}

Push-Location $appDir
try {
    # cmake/xmake write warnings to stderr; judge success by exit code only (Windows PowerShell 5.1 would otherwise abort)
    $ErrorActionPreference = 'Continue'
    cmake -G 'Unix Makefiles' -B build
    if ($LASTEXITCODE) { throw 'cmake configure failed' }
    xmake -C build -j
    if ($LASTEXITCODE) { throw 'xmake build failed' }
} finally {
    Pop-Location
}
Get-ChildItem (Join-Path $appDir 'bin') -Recurse -Filter *.xe | ForEach-Object { Write-Host "Built: $($_.FullName)" }