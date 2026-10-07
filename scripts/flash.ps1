<#
.SYNOPSIS  Flashes (xflash) the built firmware, or runs it from RAM with xSCOPE (xrun).
.EXAMPLE   .\scripts\flash.ps1 -AdapterId 4NV62AKC
.EXAMPLE   .\scripts\flash.ps1 -Run          # xrun --xscope, nothing is written to flash
#>
param(
    [string]$Xe = 'sw_pigigbox\app_pigigbox_xk_316_mc\bin\2AMi16o16xxxaax\app_pigigbox_xk_316_mc_2AMi16o16xxxaax.xe',
    [string]$AdapterId,
    [switch]$Run
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
. (Join-Path $PSScriptRoot 'xtc-env.ps1')

$xePath = Join-Path $repo $Xe
if (-not (Test-Path $xePath)) { throw "Not built: $xePath (run scripts\build.ps1)" }
$adapter = if ($AdapterId) { @('--adapter-id', $AdapterId) } else { @() }

$ErrorActionPreference = 'Continue'   # xrun/xflash log to stderr; judge by exit code
if ($Run) { xrun @adapter --xscope $xePath } else { xflash @adapter $xePath }
if ($LASTEXITCODE) { throw "xrun/xflash failed (exit $LASTEXITCODE)" }