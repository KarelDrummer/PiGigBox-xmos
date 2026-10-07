---
name: xmos-app-customization
description: Customise the PiGigBox USB Audio firmware (XUA / lib_xua on xcore.ai XK-AUDIO-316-MC) - channel counts, sample rates, clocking, USB descriptors, DAC/ADC init, DSP hooks, new build configs. Use for any change to sw_pigigbox application behaviour.
---

# Customising the PiGigBox application

App: `sw_pigigbox/app_pigigbox_xk_316_mc` (copy of upstream `app_usb_aud_xk_316_mc`, sw_usb_audio 9.2.0).
Config name `2AMi16o16xxxaax` = UAC2, Async, I2S Master, 16 in, 16 out, no MIDI, no S/PDIF, ADAT in/out.

## Where
See `docs/customization.md` for the file map. Core rules:
- Behaviour switches: defines in `src/core/xua_conf.h` (all guarded with `#ifndef`) or `-D` flags in the app
  `CMakeLists.txt` (`APP_COMPILER_FLAGS_<config>`). Prefer the CMake flag for config-specific values.
- Hardware hooks (codec init, SR change, mute): `src/extensions/audiohw.xc`, `audiostream.xc`.
- DSP/sample processing: `user_buffer_management.xc` (lib_xua optional-header mechanism, see lib_xua docs).
- Extra tasks in `main()`: `xua_conf_tasks.h` / `xua_conf_globals.h` – mind the 8 hardware threads per tile and memory.
- Do not edit `lib_*` – override from the app.

## Workflow
1. Check upstream behaviour: read `lib_xua/doc` and the matching `xua_conf_full.h` defaults in
   `lib_xua/lib_xua/api/xua_conf_full.h`.
2. Change the app; keep upstream deviations small and commented (`sh scripts/diff-upstream.sh` lists them).
3. Build (skill `xmos-build-flash`). Check the tile memory report and that constraints PASS.
4. Test with `xrun` (RAM) before `xflash`.

## Gotchas
- Changing channel counts also changes USB descriptors -> host (Windows) may cache the old device; use a new
  PID (`PID_AUDIO_2`) or remove the device in Device Manager when testing.
- ADAT above 48 kHz uses sample multiplexing (SMUX) and reduces channel count; the baseline is fixed 48 kHz
  (`MIN_FREQ = MAX_FREQ = 48000`). Raising `MAX_FREQ` needs matching channel/MCLK settings and memory.
- XC code is not parsed by VS Code C/C++ tooling; trust `xcc` diagnostics.
- New build config: add `set(APP_COMPILER_FLAGS_<name> ...)` before `XMOS_REGISTER_APP()`; output is `bin/<name>/`.