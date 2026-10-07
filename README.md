# PiGigBox-xmos

Custom firmware for the **XK-AUDIO-316-MC** (xcore.ai) multichannel USB Audio board, based on the
XMOS `sw_usb_audio` reference design. The baseline reproduces the firmware currently flashed on the
board: **`2AMi16o16xxxaax`** – USB Audio Class 2.0, asynchronous, I2S master, 16 in / 16 out,
ADAT Rx/Tx, fixed 48 kHz.

## Layout (XCommon CMake *sandbox*)

The XMOS sandbox layout puts every module and application directly in the repository root, each one
its own git repository (here: git submodules). Own code lives only in `sw_pigigbox/`.

```
PiGigBox-xmos/
├── sw_pigigbox/                     <- OWN CODE (application)
│   ├── CMakeLists.txt               multi-app root
│   ├── deps.cmake                   dependency list (must match the submodules)
│   ├── shared/version.h             USB device version (bcdDevice)
│   └── app_pigigbox_xk_316_mc/      app: sources + CMakeLists.txt with the build config
│       └── src/{core,extensions}/   xua_conf*.h, board .xn, user extension hooks
├── lib_xua/ lib_xud/ lib_i2c/ lib_i2s/ lib_board_support/ lib_adat/ lib_spdif/ lib_mic_array/
│   lib_sw_pll/ lib_xassert/ lib_logging/ lib_locks/ lib_xcore_math/   <- submodules, pinned
├── sw_usb_audio/                    <- submodule: untouched upstream reference (v9.2.0)
├── scripts/                         build / flash / VS Code / dependency helpers
├── docs/                            dependencies and customisation notes
├── .vscode/                         settings, tasks, extension recommendations
└── .github/                         Copilot instructions and skills
```

Never edit anything inside the submodules. Customise by editing the app in `sw_pigigbox/` – XUA is
designed for that (`xua_conf*.h` defines and the user hooks in `src/extensions/`).

## Requirements

- XMOS XTC Tools 15.3.x (ships XCommon CMake), CMake >= 3.21, Git >= 2.25 – see the XTC Tools guide.
- VS Code with **CMake Tools**, **Task Runner** and **C/C++** (recommended in `.vscode/extensions.json`).

## Getting started

```powershell
git clone --recurse-submodules git@github.com:KarelDrummer/PiGigBox-xmos.git
cd PiGigBox-xmos
.\scripts\build.ps1              # configure + build, output in sw_pigigbox\app_pigigbox_xk_316_mc\bin\
.\scripts\flash.ps1              # xflash to the board   (.\scripts\flash.ps1 -Run = xrun from RAM)
.\scripts\open-vscode.ps1        # VS Code with the XTC environment
```

(`git submodule update --init` if you forgot `--recurse-submodules`.)

### VS Code

As described in the XTC Tools guide ("Using VS Code"), VS Code must inherit the XTC environment, so start
it with `scripts\open-vscode.ps1` (close other VS Code windows first). Then use the *Task Runner* view or
*Terminal → Run Task…*: `XMOS: Build`, `XMOS: Flash …`, `XMOS: Run …`, `XMOS: Debug (xgdb)`.
If you prefer the CMake Tools panel, pick the **[Unspecified]** kit; `.vscode/settings.json` already sets
the `Unix Makefiles` generator and the application source directory. If several xTAGs are connected, add
`"--adapter-id", "<id>"` to the args in `.vscode/tasks.json` (list them with `XMOS: List devices`).

## Baseline vs. upstream

`scripts\diff-upstream.ps1` shows the delta against upstream. Currently only
`MIN_FREQ`/`MAX_FREQ` = 48000 in `xua_conf.h`. The baseline build was verified against the flashed
firmware: identical code and data (only embedded source paths differ).

See [docs/dependencies.md](docs/dependencies.md) and [docs/customization.md](docs/customization.md).