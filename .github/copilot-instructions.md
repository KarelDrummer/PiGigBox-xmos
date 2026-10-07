# Copilot instructions – PiGigBox-xmos

XMOS xcore.ai (XK-AUDIO-316-MC) USB Audio firmware built with XTC Tools 15.3 and XCommon CMake.

- Repository root = XCommon CMake *sandbox*. Own code lives only in `sw_pigigbox/`. Directories `lib_*` and
  `sw_usb_audio` are git submodules pinned to released tags: never edit or commit inside them.
- Application: `sw_pigigbox/app_pigigbox_xk_316_mc`, build config `2AMi16o16xxxaax`
  (UAC2, async, I2S master, 16 in/16 out, ADAT, fixed 48 kHz).
- Build/flash environment is the XTC Tools environment (`. .\scripts\xtc-env.ps1`, dot-sourced). Helper scripts are PowerShell
  (`ExecutionPolicy` RemoteSigned for the user is required). Build: `.\scripts\build.ps1 [-Clean]`; flash: `.\scripts\flash.ps1 [-Run] [-AdapterId <id>]`.
- Source languages: XC (`.xc`), C, assembly. XC syntax (`par`, `chanend`, `select`, `interface`, `[[distributable]]`) is
  not understood by C tooling; rely on `xcc`/`xmake` output, not on IntelliSense, for correctness.
- Prefer configuration through `xua_conf*.h` defines and the XUA user hooks in `src/extensions/` over patching libraries.
- Libraries are on the newest stable releases except lib_sw_pll (2.4.1) and lib_xassert (4.3.2), which are held back
  because newer ones break lib_board_support 1.5.0. Do not bump them without reading `docs/dependencies.md`.
- Keep `sw_pigigbox/deps.cmake` versions in sync with the submodule pins (`docs/dependencies.md`).
- Never flash (`xflash`) or run on hardware without the user asking; building is always safe.
- Build output (`build/`, `bin/`) is git-ignored.

Skills in `.github/skills/`: `xmos-build-flash`, `xmos-dependencies`, `xmos-app-customization`.