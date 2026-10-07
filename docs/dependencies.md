# Dependencies

All XMOS libraries are git submodules in the repository root (XCommon CMake sandbox). XCommon CMake
never touches modules that are already present, so the submodule commit **is** the version used.
`sw_pigigbox/deps.cmake` repeats the versions only as a fallback for cloning missing modules – keep both in sync.

## Pinned versions (= the flashed firmware, sw_usb_audio 9.2.0 dependency set)

| Module | Pinned | Newest stable upstream (checked 2026-10-07) |
|---|---|---|
| lib_xua | v5.2.0 | v5.5.0 |
| lib_xud | v4.0.0 | v4.0.1 |
| lib_i2c | v6.4.0 | v6.4.1 |
| lib_i2s | v6.0.1 | v6.0.1 |
| lib_board_support | v1.3.0 | v1.5.0 |
| lib_adat | v2.0.1 | v2.0.1 |
| lib_spdif | v7.0.0 | v7.0.0 |
| lib_mic_array | v5.5.0 | v7.1.0 |
| lib_sw_pll | v2.4.0 | v2.5.0 |
| lib_xassert | v4.3.1 | v5.0.0 |
| lib_logging | v3.4.0 | v3.4.0 |
| lib_locks | v2.3.2 | v2.4.0 |
| lib_xcore_math | v2.4.0 | v3.0.0 |
| sw_usb_audio (reference only) | v9.2.0 | v9.2.0 |

Run `.\scripts\deps-status.ps1` for the current state.

The pins were chosen deliberately: the goal of the baseline is to reproduce the flashed firmware exactly.
Several newer tags are major-version bumps (lib_xassert 5, lib_xcore_math 3, lib_mic_array 7) and
`sw_usb_audio` 9.2.0 has not been validated against them.

## Updating a module

```
git -C lib_xua fetch --tags
git -C lib_xua checkout v5.5.0
```

1. Update the matching version in `sw_pigigbox/deps.cmake` (only the four direct dependencies are listed; transitive
   ones such as lib_xud, lib_adat, lib_spdif follow from `lib_xua/lib_xua/lib_build_info.cmake`).
2. Read the module `CHANGELOG.rst` (breaking changes), rebuild with `.\scripts\build.ps1 -Clean`.
3. Keep upgrades in one module at a time, check `sw_pigigbox/app_*/build/manifest.txt` (the versions actually used)
   and test on hardware before `git add lib_xua` (that records the new pin).

## Updating the upstream reference

Check out a newer `sw_usb_audio` tag, run `.\scripts\diff-upstream.ps1` and port wanted changes into
`sw_pigigbox/app_pigigbox_xk_316_mc` by hand.