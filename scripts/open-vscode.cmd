@echo off
rem Opens VS Code with the XTC Tools environment inherited (required by the XMOS VS Code workflow).
rem Close all other VS Code windows first, otherwise the running instance (without XTC env) is reused.
call "%~dp0xtc-env.cmd" || exit /b 1
code "%~dp0.."