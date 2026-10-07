<#
.SYNOPSIS  Shows the pinned version of every submodule next to the newest stable upstream tag.
#>
$repo = Split-Path $PSScriptRoot -Parent
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
    $mark = if ($pinned -ne $latest) { '  <- newer available' } else { '' }
    '{0,-20} pinned {1,-10} latest {2,-10}{3}' -f $name, $pinned, $latest, $mark
}