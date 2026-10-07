#!/bin/sh
# Shows every local change of the PiGigBox app relative to the untouched upstream reference
# (submodule sw_usb_audio, app_usb_aud_xk_316_mc). Build/CMake files are expected to differ.
# Run with Git Bash / any POSIX sh:  sh scripts/diff-upstream.sh
cd "$(dirname "$0")/.." || exit 1
git diff --no-index --ignore-cr-at-eol --stat sw_usb_audio/app_usb_aud_xk_316_mc/src sw_pigigbox/app_pigigbox_xk_316_mc/src 2>/dev/null
git diff --no-index --ignore-cr-at-eol sw_usb_audio/app_usb_aud_xk_316_mc/src sw_pigigbox/app_pigigbox_xk_316_mc/src 2>/dev/null
