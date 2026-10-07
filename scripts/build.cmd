@echo off
rem Builds the PiGigBox application with XCommon CMake (as documented in the XTC Tools guide).
rem Usage: scripts\build.cmd [clean]
setlocal
call "%~dp0xtc-env.cmd" || exit /b 1

for %%i in ("%~dp0..") do set "ROOT=%%~fi"
set "APP_DIR=%ROOT%\sw_pigigbox\app_pigigbox_xk_316_mc"
if /i "%~1"=="clean" (
    if exist "%APP_DIR%\build" rmdir /s /q "%APP_DIR%\build"
    if exist "%APP_DIR%\bin" rmdir /s /q "%APP_DIR%\bin"
)

pushd "%APP_DIR%"
cmake -G "Unix Makefiles" -B build || goto :fail
xmake -C build -j || goto :fail
popd
echo Built: %APP_DIR%\bin
exit /b 0

:fail
popd
exit /b 1