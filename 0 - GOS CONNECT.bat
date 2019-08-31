::           Author  :  John Clippinger   
::           E-Mail  :  jclippinger@geeksonsite.com  
::           website :  www.geeksonsite.com      
::           Updated :  7/22/2018
::           File    :  GOS Connect Tool   
::           Version :  1.0.0.9

@echo off
Setlocal
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo.
    echo Requesting Administrative Privileges
    echo Please Wait...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

mode con: cols=86 lines=32
color 9F&prompt $v
Title = ----- GEEKS ON SITE RESCUE -----
	            
:top
echo.
echo.
echo   	  	          Welcome to Geeks On Site Connect
echo.
echo. 
echo   	  ����������������������������������������������������������������ͻ
echo 	  �                                                                �
echo 	  �                                                                �
echo 	  �  Please Make a Choice By typing the corresponding number...    �
echo 	  �                                                                �
echo 	  �                                                                �
echo 	  �  1. Geeks On Site Website                                      �
echo 	  �  2. Ping Test                                                  �
echo 	  �  3. System Restore                                             �
echo 	  �  4. Safe Mode with Networking -------------------(Auto Reboot) �
echo 	  �  5. Disable Windows Fire Wall                                  �
echo 	  �  6. Microsoft System Configuration -----------------(MSCONFIG) �
echo 	  �  7. Turn off User Account Controls -------(Reboot if Vista OS) �
echo 	  �  8. Activate Admin Account                                     �
echo 	  �  9. Repair Network ------------------------------(Auto Reboot) �
echo 	  �                                                                �
echo 	  �                                                                �
Echo 	  ����������������������������������������������������������������ͼ
echo.
echo.
echo.
set /p "option= Enter Choice: "
echo.
echo.
if %option%==1  goto Geeks On Site
if %option%==2  goto Ping Test     
if %option%==3  goto System Restore
if %option%==4  goto Safe Mode networking
if %option%==5  goto Turn off Windows Fire Wall
if %option%==6  goto MSCONFIG
if %option%==7  goto UAC OFF
if %option%==8  goto Admin Activate
if %option%==9  goto Repair Network

*****************************************

:: 1
:Geeks On Site

REM Check Windows Version
for /f "delims=" %%I in ('ver') do set "ver=%%I"
if "%ver%" neq "%ver:Version 5.=%" goto Internet_Explorer
if "%ver%" neq "%ver:Version 6.=%" goto Internet_Explorer
if "%ver%" neq "%ver:Version 10.=%" goto Choose_Browser
goto warn_and_exit

: Choose_Browser
SET /P ANSWER=What browser do you want to open? (I) Internet Explorer or (E) Edge ...  
echo You chose: %ANSWER% 
if /i "%ANSWER%"=="I" goto Internet_Explorer
if /i "%ANSWER%"=="E" goto Edge


: Internet_Explorer
start iexplore.exe -extoff "www.geeksonsite.com"
cls
goto top

: Edge
start microsoft-edge:"www.geeksonsite.com"
cls
goto top

******************************************

:: 2
:Ping Test
ping www.google.com
Pause 
cls
goto top

******************************************

:: 3
: System Restore
Echo Off

REM Check Windows Version
for /f "delims=" %%I in ('ver') do set "ver=%%I"
if "%ver%" neq "%ver:Version 5.=%" goto nt5
if "%ver%" neq "%ver:Version 6.=%" goto nt6
if "%ver%" neq "%ver:Version 10.=%" goto nt6
goto warn

:nt5
%SystemRoot%\system32\restore\rstrui.exe
cls
goto top

:nt6
systempropertiesprotection
cls
goto top

Echo On

:warn
echo Machine OS cannot be determined.

Pause
cls
goto top

******************************************

:: 4
: Safe Mode networking
Echo Off

REM Check Windows Version
for /f "delims=" %%I in ('ver') do set "ver=%%I"
if "%ver%" neq "%ver:Version 5.=%" goto ver_nt5x
if "%ver%" neq "%ver:Version 6.=%" goto ver_nt6x
if "%ver%" neq "%ver:Version 10.=%" goto ver_nt6x
goto warn_and_exit

:ver_nt5x
bootcfg /raw /a /safeboot:network /id 1
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v "*UndoSB" /t REG_SZ /d "bootcfg /raw /fastdetect /id 1"
SHUTDOWN -r -f -t 07
goto end

:ver_nt6x
bcdedit /set {current} safeboot network
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v "*UndoSB" /t REG_SZ /d "bcdedit /deletevalue {current} safeboot"
SHUTDOWN -r -f -t 07
goto end

Echo On

:warn_and_exit
echo Machine OS cannot be determined.

:end 
exit

*****************************************

:: 5
: Turn off Windows Fire Wall
netsh firewall set opmode disable
cls
goto top

******************************************

:: 6
: MSCONFIG
start MSCONFIG
cls
goto top

******************************************

:: 7
: UAC OFF
for /f "delims=" %%I in ('ver') do set "ver=%%I"
if "%ver%" neq "%ver:Version 5.=%" goto UAC None
C:\Windows\System32\cmd.exe /c %windir%\System32\reg.exe ADD  HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v  EnableLUA /t REG_DWORD /d 0 /f 
: UAC None
if "%ver%" neq "%ver:Version 5.=%" echo Operation Completed
Pause
cls
goto top

******************************************

: 8
:Admin Activate
for /f "delims=" %%I in ('ver') do set "ver=%%I"
if "%ver%" neq "%ver:Version 5.=%" cls
if "%ver%" neq "%ver:Version 5.=%" echo Notice
if "%ver%" neq "%ver:Version 5.=%" echo.
if "%ver%" neq "%ver:Version 5.=%" echo.
if "%ver%" neq "%ver:Version 5.=%" echo Hidden Admin Account is inabled by default on Windows XP when in safe Mode
if "%ver%" neq "%ver:Version 5.=%" echo We will reboot so we can Login to the Admin Account there
if "%ver%" neq "%ver:Version 5.=%" pause
if "%ver%" neq "%ver:Version 5.=%" goto Safe Mode networking
net user administrator /active:yes
pause

msg "%username%" Please switch users or log off to access the Admin account

cls
goto top

******************************************

:: 9
:Repair Network
ipconfig /flushdns
netsh winsock reset
shutdown /r

******************************************