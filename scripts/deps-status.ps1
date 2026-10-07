<#
.SYNOPSIS  Shows the pinned version of every submodule next to the newest stable upstream tag.
#>
$repo = Split-Path $PSScriptRoot -Parent
# Newest releases that are known not to work with the rest of the pinned set (see docs/dependencies.md)
$heldBack = @{
    lib_sw_pll  = 'v2.5.0 changes the sw_pll_* init API (new tile_mask arg); lib_board_support 1.5.0 / lib_xua 5.5.0 not adapted'
    lib_xassert = 'v5.0.0 defines UNSAFE=unsafe, breaks lib_board_support 1.5.0'
}
$paths = git -C $repo submodule --quiet foreach --recursive 'echo $displaypath'
foreach ($name in $paths) {
    $dir = Join-Path $repo $name
    $pinned = git -C $dir describe --tags --exact-match 2>$null
    if (-not $pinned) { $pinned = git -C $dir rev-parse --short HEAD }
    $latest = git -C $dir ls-remote --tags --refs origin 'v*' |
        ForEach-Object { ($_ -split 'refs/tags/')[1] } |
        Where-Object { $_ -match '^v\d+\.\d+\.\d+$' } |
        Sort-Object { [version]$_.Substring(1) } |
        Select-Object -Last 1
    $mark = ''
    if ($pinned -ne $latest) {
        $mark = if ($heldBack.ContainsKey($name)) { "  <- held back: $($heldBack[$name])" } else { '  <- newer available' }
    }
    '{0,-20} pinned {1,-10} latest {2,-10}{3}' -f $name, $pinned, $latest, $mark
}