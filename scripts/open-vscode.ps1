<#
.SYNOPSIS  Opens VS Code with the XTC Tools environment inherited (required by the XMOS VS Code workflow).
.NOTES     Close all other VS Code windows first, otherwise the running instance (without XTC env) is reused.
#>
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'xtc-env.ps1')
code (Split-Path $PSScriptRoot -Parent)