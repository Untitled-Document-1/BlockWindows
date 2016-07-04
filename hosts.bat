@echo off
REM This blocks MS telemetry IP's from hosts file. Appends to current hosts file, only run once.
REM WIN10 blocks this method, if running WIN10 add the entries in the file 'hosts' to your router or firewall blocklist

openfiles.exe 1>nul 2>&1
if errorlevel 1 ECHO You need to run this script from an elevated command prompt. Exiting. && EXIT /B 1

type %~dp0hosts.list >> %windir%\system32\Drivers\etc\hosts
echo Completed
pause
)
