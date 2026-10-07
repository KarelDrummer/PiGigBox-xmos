#!/bin/sh
# Shows the pinned version of every submodule next to the newest stable upstream tag.
# Run with Git Bash / any POSIX sh:  sh scripts/deps-status.sh
cd "$(dirname "$0")/.." || exit 1
git submodule foreach --quiet '
  pinned=$(git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)
  latest=$(git ls-remote --tags --refs --sort=-v:refname origin "v*" | sed "s|.*refs/tags/||" | grep -E "^v[0-9]+\.[0-9]+\.[0-9]+$" | head -n1)
  mark=""; [ "$pinned" != "$latest" ] && mark="  <- newer available"
  printf "%-20s pinned %-10s latest %-10s%s\n" "$name" "$pinned" "$latest" "$mark"
'