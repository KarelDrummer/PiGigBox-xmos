<#
.SYNOPSIS
  Shows every local change of the PiGigBox app relative to the untouched upstream reference
  (submodule sw_usb_audio, app_usb_aud_xk_316_mc). The 800 MHz hiBW .xn and the CMake files are
  intentionally not carried over, so only src\ is compared.
#>
$repo = Split-Path $PSScriptRoot -Parent
Push-Location $repo
try {
    $a = 'sw_usb_audio/app_usb_aud_xk_316_mc/src'
    $b = 'sw_pigigbox/app_pigigbox_xk_316_mc/src'
    git -c core.safecrlf=false diff --no-index --ignore-cr-at-eol --stat $a $b 2>$null
    git -c core.safecrlf=false diff --no-index --ignore-cr-at-eol $a $b 2>$null
} finally {
    Pop-Location
}