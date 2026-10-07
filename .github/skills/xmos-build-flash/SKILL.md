---
name: xmos-build-flash
description: Build, run and flash the PiGigBox XMOS firmware (XTC Tools 15.3, XCommon CMake) and set up or troubleshoot the VS Code workflow. Use when asked to compile, rebuild, flash, run on the board, list xTAG devices, or fix build environment errors.
---

# Build, run, flash

## Environment
XTC Tools must be on PATH and `XMOS_CMAKE_PATH` must point to the XCommon CMake of the XTC Tools.
`scripts\xtc-env.cmd` does this (runs `SetEnv.bat` of the newest install in `C:\Program Files\XMOS\XTC`,
override with `XTC_VERSION_DIR`). A global `XMOS_CMAKE_PATH` pointing to some other checkout is overridden by it.
Run commands as `cmd /c "scripts\build.cmd"` – PowerShell `.ps1` scripts may be blocked by execution policy.

## Build
```
cmd /c "scripts\build.cmd"          # incremental
cmd /c "scripts\build.cmd clean"    # removes app build/ and bin/ first
```
Equivalent manual steps (inside `sw_pigigbox\app_pigigbox_xk_316_mc` with the XTC env):
`cmake -G "Unix Makefiles" -B build` then `xmake -C build -j`.
Result: `sw_pigigbox\app_pigigbox_xk_316_mc\bin\2AMi16o16xxxaax\app_pigigbox_xk_316_mc_2AMi16o16xxxaax.xe`.
Success = "Constraints checks PASSED" for both tiles and exit code 0. Known harmless warnings:
`resetAsynchFeedback` deprecated, `#warning OUT Vols in mixer`, CMake dev warning in xcommon.cmake.

## Run / flash (only when the user asks – this touches hardware)
- List devices: `xrun -l`
- RAM only, non-persistent: `scripts\flash.cmd run [adapter-id]` (xrun --xscope)
- Persistent flash: `scripts\flash.cmd flash [adapter-id]` (xflash)
- Interactive debug: `xgdb <xe>` then `connect`, `load`, `continue`.
With several xTAGs connected always pass `--adapter-id`.

## VS Code (per XTC Tools guide "Using VS Code")
- Start via `scripts\open-vscode.cmd` so VS Code inherits the XTC environment (close other VS Code windows first).
- `.vscode/settings.json` must contain `"cmake.generator": "Unix Makefiles"`; VS Code may append absolute paths
  to it – remove those if the folder is moved.
- Extensions: CMake Tools (kit **[Unspecified]**), Task Runner, C/C++. Tasks live in `.vscode/tasks.json`.
- If configure misbehaves after moving the repo, delete `sw_pigigbox/app_pigigbox_xk_316_mc/build` and configure again.

## Troubleshooting
- `XMOS_CMAKE_PATH` empty / `xcommon.cmake` not found -> use `scripts\xtc-env.cmd` / `open-vscode.cmd`.
- `lib_xua` or other module missing / being cloned -> submodules not initialised: `git submodule update --init`.
- Tile memory over budget -> reduce channels/features in `xua_conf.h`.