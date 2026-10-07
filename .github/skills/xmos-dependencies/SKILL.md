---
name: xmos-dependencies
description: Manage the XMOS library submodules (lib_xua, lib_xud, lib_i2c, ...) of PiGigBox - check pinned vs latest versions, upgrade or downgrade a module, sync deps.cmake, compare against upstream sw_usb_audio. Use for any task about library versions, submodules or upstream updates.
---

# XMOS dependencies

Layout rules (XCommon CMake sandbox): all `lib_*` modules and `sw_usb_audio` are git submodules in the
repository root, pinned to release tags. XCommon CMake never modifies a module already present, so the submodule
commit is authoritative; `sw_pigigbox/deps.cmake` is a fallback and must match.

## Check
- `.\scripts\deps-status.ps1` – pinned vs newest stable tag.
- After a build, `sw_pigigbox/app_pigigbox_xk_316_mc/build/manifest.txt` lists the versions really used.

## Upgrade one module
1. `git -C lib_xyz fetch --tags` ; `git -C lib_xyz checkout vX.Y.Z`
2. Read `lib_xyz/CHANGELOG.rst` for breaking changes (major bumps need code changes).
3. Update `sw_pigigbox/deps.cmake` if it is a listed dependency; `docs/dependencies.md` table.
4. `.\scripts\build.ps1 -Clean`; fix errors in the app, not in the library.
5. Stage the new pin with `git add lib_xyz`. Change one module at a time; recommend hardware testing before flashing.

## Baseline
Pins reproduce the firmware flashed on the board (sw_usb_audio 9.2.0 set). Do not bump versions as a side effect of
other work. Major jumps that exist upstream: lib_xassert 5, lib_xcore_math 3, lib_mic_array 7.

## Upstream reference
`sw_usb_audio` (submodule) is untouched upstream. `.\scripts\diff-upstream.ps1` shows local app deviations.
To take a new upstream release: checkout the new tag there, diff against it, port changes manually.

## Rules
Never commit inside a submodule, never edit library sources in place. If a library needs a fix, override via the
app (`xua_conf*.h`, extension hooks) or fork the library and change its URL in `.gitmodules` deliberately.