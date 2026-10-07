@echo off
rem Flashes the built firmware to the board (xflash), or runs it from RAM with xSCOPE (xrun).
rem Usage: scripts\flash.cmd [flash|run] [adapter-id]
setlocal
call "%~dp0xtc-env.cmd" || exit /b 1

for %%i in ("%~dp0..") do set "ROOT=%%~fi"
set "XE=%ROOT%\sw_pigigbox\app_pigigbox_xk_316_mc\bin\2AMi16o16xxxaax\app_pigigbox_xk_316_mc_2AMi16o16xxxaax.xe"
if not exist "%XE%" ( echo ERROR: not built: %XE% & exit /b 1 )

set "MODE=%~1"
if "%MODE%"=="" set "MODE=flash"
set "ADAPTER="
if not "%~2"=="" set "ADAPTER=--adapter-id %~2"

if /i "%MODE%"=="run" ( xrun %ADAPTER% --xscope "%XE%" ) else ( xflash %ADAPTER% "%XE%" )