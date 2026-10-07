# Customisation

The app is a copy of `app_usb_aud_xk_316_mc` from sw_usb_audio 9.2.0 limited to one build configuration.

## Where to change things

| Goal | File |
|---|---|
| Channel counts, features, sample rates, USB strings/IDs, clocking | `src/core/xua_conf.h` (every `#ifndef X` can also be overridden with `-DX=...` in the CMake config) |
| Extra tasks / globals for `main()` | `src/core/xua_conf_tasks.h`, `src/core/xua_conf_globals.h` |
| Codec/DAC/ADC init, sample-rate change, mute | `src/extensions/audiohw.xc`, `audiostream.xc` |
| Host activity, user buffer processing (DSP hook) | `hostactive.xc`, `user_buffer_management.xc` |
| HID buttons | `hidbuttons.xc`, `hid_report_descriptor.h` |
| Board pin map / flash description | `src/core/xk-audio-316-mc.xn` |
| Compiler flags / defines per build config | `app_pigigbox_xk_316_mc/CMakeLists.txt` (`APP_COMPILER_FLAGS_<config>`) |
| Device version shown to the host | `sw_pigigbox/shared/version.h` |

## Build configurations

The config name encodes the feature set (see the comment in the app `CMakeLists.txt`). To add a variant,
add another `set(APP_COMPILER_FLAGS_<name> ${PIGIGBOX_FLAGS} -D...)`; each config builds into
`bin/<name>/`. Update the paths in `.vscode/tasks.json` and `scripts/flash.cmd` if you want to flash another one.
Upstream's other configs (S/PDIF, MIDI, hiBW 800 MHz, mixer, TDM…) are in
`sw_usb_audio/app_usb_aud_xk_316_mc/configs_*.cmake` for reference.

## Baseline delta from upstream

- `MIN_FREQ = MAX_FREQ = 48000` (`xua_conf.h`) – the flashed firmware only runs at 48 kHz.
- Config files reduced to `2AMi16o16xxxaax`; app renamed to `app_pigigbox_xk_316_mc`.

## Hardware notes

- Do not mix configs: ADAT at >48 kHz needs SMUX and different `MAX_FREQ`/channel counts.
- Flashing replaces the firmware on the board's QSPI flash; `xrun` runs from RAM only (non-persistent) and is the
  safe way to test.