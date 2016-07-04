@ECHO OFF
openfiles.exe 1>nul 2>&1
IF errorlevel 1 ECHO You need to run this script from an elevated command prompt. Exiting. && EXIT /B 1
REM Uses route comand to block or unblock Microsoft servers, including Outlook, Hotmail, Live.com, Bing.com
CHOICE /C BU /M "Type [B] to block Microsoft hosts or [U] to unblock Microsoft hosts" /N
IF %errorlevel%==1 SET _CHOICE=Blocking& SET _ROUTECMD=route -p add
IF %errorlevel%==2 SET _CHOICE=Unblocking& SET _ROUTECMD=route -p delete
FOR /F "tokens=1,2 delims=," %%A IN (mshosts.list) DO (
ECHO. & ECHO %_CHOICE% %%A
%_ROUTECMD% %%B/32 127.0.0.1
)
