@ECHO off

REM call a .ps1 script from a .bat file while mantaining the window hidden.

if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit

powershell.exe -windowstyle hidden -executionpolicy bypass -noexit "& C:\paht\to\file.ps1"

exit