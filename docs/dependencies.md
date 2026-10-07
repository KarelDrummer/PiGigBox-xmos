# Dependencies

All XMOS libraries are git submodules in the repository root (XCommon CMake sandbox). XCommon CMake
never touches modules that are already present, so the submodule commit **is** the version used.
`sw_pigigbox/deps.cmake` repeats the versions only as a fallback for cloning missing modules – keep both in sync.

## Pinned versions

All modules are on the newest stable release (checked 2026-10-07) **except** two that are deliberately held back:

| Module | Pinned | Newest stable | Note |
|---|---|---|---|
| lib_xua | v5.5.0 | v5.5.0 | |
| lib_xud | v4.0.1 | v4.0.1 | |
| lib_dfu | v2.1.0 | v2.1.0 | new dependency of lib_xua >= 5.4 |
| lib_i2c | v6.4.1 | v6.4.1 | |
| lib_i2s | v6.0.1 | v6.0.1 | |
| lib_board_support | v1.5.0 | v1.5.0 | |
| lib_adat | v2.0.1 | v2.0.1 | |
| lib_spdif | v7.0.0 | v7.0.0 | |
| lib_mic_array | v7.1.0 | v7.1.0 | |
| lib_xcore_math | v3.0.0 | v3.0.0 | |
| lib_logging | v3.4.0 | v3.4.0 | |
| lib_locks | v2.4.0 | v2.4.0 | |
| **lib_sw_pll** | **v2.4.1** | v2.5.0 | v2.5.0 changes `sw_pll_fixed_clock()` & co. (extra `tile_mask` argument); lib_board_support 1.5.0 still calls the old API -> compile error |
| **lib_xassert** | **v4.3.2** | v5.0.0 | v5.0.0 defines `UNSAFE` as `unsafe` in XC, which breaks lib_board_support 1.5.0 (`cs2100.h`) -> compile error. v4.3.3 is mentioned in the changelog but not tagged |
| sw_usb_audio (reference only) | v9.2.0 | v9.2.0 | its own dependency set is older (lib_xua 5.2.0 ...) |

lib_sw_pll 2.4.1 and lib_xassert 4.3.2 are exactly the versions that lib_xua 5.5.0 and lib_board_support 1.5.0 declare
in their `lib_build_info.cmake`. Re-check them when a newer lib_board_support / lib_xua is released.

`.\scripts\deps-status.ps1` shows the current state (and flags the held-back modules).

History: the first baseline used the dependency set of sw_usb_audio 9.2.0 (lib_xua 5.2.0 ...) and was verified to
produce code and data identical to the firmware flashed on the board. The update to the versions above builds
cleanly (both tiles pass the memory constraints) but has **not been tested on hardware** yet.
## Updating a module

```
git -C lib_xua fetch --tags
git -C lib_xua checkout v5.5.0
```

1. Update the matching version in `sw_pigigbox/deps.cmake` (direct dependencies plus the two held-back modules are listed; the other transitive
   ones such as lib_xud, lib_adat, lib_spdif follow from `lib_xua/lib_xua/lib_build_info.cmake`, so a transitive
   module that you bump by hand is only recorded by its submodule pin).
2. Read the module `CHANGELOG.rst` (breaking changes), rebuild with `.\scripts\build.ps1 -Clean`.
3. Keep upgrades in one module at a time, check `sw_pigigbox/app_*/build/manifest.txt` (the versions actually used)
   and test on hardware before `git add lib_xua` (that records the new pin).

## Updating the upstream reference

Check out a newer `sw_usb_audio` tag, run `.\scripts\diff-upstream.ps1` and port wanted changes into
`sw_pigigbox/app_pigigbox_xk_316_mc` by hand.