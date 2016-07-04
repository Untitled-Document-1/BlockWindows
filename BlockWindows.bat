@echo off
openfiles.exe 1>nul 2>&1
if errorlevel 1 ECHO You need to run this script from an elevated command prompt. Exiting. && EXIT /B 1

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM --- uninstall updates
echo Uninstalling updates, be patient...
for %%f in ( %~dp0*.list ) do (
    for /F "tokens=1,2,*" %%k in (%%~f) do (
        if "%%~l" gtr "%~1" (
            set _LIST=!_LIST! %%~k
            < nul: set /P _=Removing KB%%~k "%%~m"
            start "%%~k" /WAIT wusa.exe /kb:%%~k /uninstall /quiet /norestart
            if errorlevel 1 (
                echo  - not found.
            ) ELSE (
                echo  - done.
            )
        )
    )
)
echo.

REM --- Hide updates
echo Hiding updates, may take a while be patient...

cscript.exe /NoLogo "%~dp0HideWindowsUpdates.vbs" %_LIST%
echo  - done.
echo.

REM --- Disable tasks
echo Disabling tasks. Depending on Windows version this may give errors, this is normal...
FOR /F "tokens=*" %%g IN (schtasks.list) DO schtasks /Change /TN "%%g" /DISABLE
echo - done.
echo.

REM --- Kill services
< NUL: SET /P =Killing Diagtrack-service (if it still exists)...
sc stop Diagtrack > NUL:
sc delete Diagtrack > NUL:
echo  - done.

echo.
echo Done. Manually Reboot for changes to take effect.
REM shutdown -r
