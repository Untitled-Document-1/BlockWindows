@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
REM This blocks MS telemetry IP's from hosts file. Appends to current hosts file, only run once.
REM WIN10 blocks this method, if running WIN10 add the entries in the file 'hosts' to your router or firewall blocklist

openfiles.exe 1>NUL 2>&1
IF errorlevel 1 ECHO You need to run this script from an elevated command prompt. Exiting. && EXIT /B 1

SET _DATESTRING=%DATE:~0,2%%DATE:~3,2%%DATE:~6,4%
SET _TIMESTRING=%TIME:~0,2%%TIME:~3,2%
SET _TIMESTRING=%_TIMESTRING: =0%

ECHO Backing up hosts file 
COPY /V /Y %windir%\system32\Drivers\etc\hosts hosts.%_DATESTRING%_%_TIMESTRING% || ECHO Error backing up hosts file

CHOICE /C BU /M "Type [B] to block hosts or [U] to unblock hosts" /N

REM Adding host lines to hosts file
IF %errorlevel%==1 ( 
	FOR /F "tokens=*" %%I IN ('type %~dp0hosts.list') DO (
		FINDSTR /C:"%%I" %windir%\system32\Drivers\etc\hosts> NUL
		IF !errorlevel! neq 0 type NUL|ECHO %%I>> %windir%\system32\Drivers\etc\hosts
	)
) 
REM Removing host lines from hosts file
IF %errorlevel%==2 (
	FOR /F "tokens=*" %%j IN ('type %~dp0hosts.list') DO (
		FINDSTR /V /C:"%%j" %windir%\system32\Drivers\etc\hosts >> original-hosts.list
	)
	MOVE /Y original-hosts.list %windir%\system32\Drivers\etc\hosts || ECHO Error restoring original hosts file
)
