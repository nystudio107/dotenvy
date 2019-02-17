@echo off

rem -------------------------------------------------------------
rem  dotenvy command line bootstrap script for Windows
rem -------------------------------------------------------------

@setlocal

set CRAFT_PATH=%~dp0

if "%PHP_COMMAND%" == "" set PHP_COMMAND=php.exe

"%PHP_COMMAND%" "%CRAFT_PATH%dotenvy" %*

@endlocal
