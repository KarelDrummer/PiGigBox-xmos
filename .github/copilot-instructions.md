# Copilot instructions – PiGigBox-xmos

XMOS xcore.ai (XK-AUDIO-316-MC) USB Audio firmware built with XTC Tools 15.3 and XCommon CMake.

- Repository root = XCommon CMake *sandbox*. Own code lives only in `sw_pigigbox/`. Directories `lib_*` and
  `sw_usb_audio` are git submodules pinned to released tags: never edit or commit inside them.
- Application: `sw_pigigbox/app_pigigbox_xk_316_mc`, build config `2AMi16o16xxxaax`
  (UAC2, async, I2S master, 16 in/16 out, ADAT, fixed 48 kHz).
- Build/flash environment is the XTC Tools environment (`scripts\xtc-env.cmd`). PowerShell scripts may be blocked by
  the execution policy – use the `.cmd` scripts. Build: `scripts\build.cmd`; flash: `scripts\flash.cmd`.
- Source languages: XC (`.xc`), C, assembly. XC syntax (`par`, `chanend`, `select`, `interface`, `[[distributable]]`) is
  not understood by C tooling; rely on `xcc`/`xmake` output, not on IntelliSense, for correctness.
- Prefer configuration through `xua_conf*.h` defines and the XUA user hooks in `src/extensions/` over patching libraries.
- Keep `sw_pigigbox/deps.cmake` versions in sync with the submodule pins (`docs/dependencies.md`).
- Never flash (`xflash`) or run on hardware without the user asking; building is always safe.
- Build output (`build/`, `bin/`) is git-ignored.

Skills in `.github/skills/`: `xmos-build-flash`, `xmos-dependencies`, `xmos-app-customization`.