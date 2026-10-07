@echo off
rem Sets up the XMOS XTC Tools environment (same as an "XTC Tools Command Prompt").
rem Usage: call scripts\xtc-env.cmd
rem Set XTC_VERSION_DIR (e.g. "C:\Program Files\XMOS\XTC\15.3.1") to pick a specific install,
rem otherwise the last one found in "%ProgramFiles%\XMOS\XTC" is used.
rem XMOS_CMAKE_PATH comes from the XTC Tools (15.3+ ships XCommon CMake) and overrides any global value.

if not defined XTC_VERSION_DIR (
    for /f "delims=" %%d in ('dir /b /ad /on "%ProgramFiles%\XMOS\XTC" 2^>nul') do set "XTC_VERSION_DIR=%ProgramFiles%\XMOS\XTC\%%d"
)
if not defined XTC_VERSION_DIR goto :notfound
if not exist "%XTC_VERSION_DIR%\SetEnv.bat" goto :notfound

call "%XTC_VERSION_DIR%\SetEnv.bat"
echo XTC Tools:       %XTC_VERSION_DIR%
echo XMOS_CMAKE_PATH: %XMOS_CMAKE_PATH%
exit /b 0

:notfound
echo ERROR: XTC Tools not found. Install them from https://www.xmos.com/software-tools or set XTC_VERSION_DIR.
exit /b 1