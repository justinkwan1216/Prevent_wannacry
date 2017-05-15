@echo off

 call :isAdmin

 if %errorlevel% == 0 (
    goto :run
 ) else (
    echo Requesting administrative privileges...
    goto :UACPrompt
 )

 exit /b

 :isAdmin
    fsutil dirty query %systemdrive% >nul
 exit /b

 :run
color 0a
@echo off

echo "ADDING rule to disable port 22 Protocol:TCP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=22 name="Block_TCP-22" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 22 on Protocol TCP"
echo.)

echo "ADDING rule to disable port 22 Protocol:UDP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=22 name="Block_UDP-22" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 22 on Protocol UDP"
echo.)

echo "ADDING rule to disable port 23 Protocol:TCP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=23 name="Block_TCP-23" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 23 on Protocol TCP"
echo.)

echo "ADDING rule to disable port 23 Protocol:UDP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=23 name="Block_UDP-23" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 23 on Protocol UDP"
echo.)

echo "ADDING rule to disable port 3389 Protocol:TCP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=3389 name="Block_TCP-3389" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 3389 on Protocol TCP"
echo.)

echo "ADDING rule to disable port 3389 Protocol:UDP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=3389 name="Block_UDP-3389" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 3389 on Protocol UDP"
echo.)

echo "ADDING rule to disable port 145 Protocol:TCP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=145 name="Block_TCP-145" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 145 on Protocol TCP"
echo.)

echo "ADDING rule to disable port 145 Protocol:UDP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=145 name="Block_UDP-145" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 145 on Protocol UDP"
echo.)

echo "ADDING rule to disable port 135 Protocol:TCP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=135 name="Block_TCP-135" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 135 on Protocol TCP"
echo.)

echo "ADDING rule to disable port 135 Protocol:UDP"
echo.
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=135 name="Block_UDP-135" >nul
if %ERRORLEVEL% == 0 (echo "rule has been added to disable port 135 on Protocol UDP"
echo.)

echo "SHUTTING DOWN port 137-139 IMMEDIATELY..."
echo.
sc stop netbt >nul
if %ERRORLEVEL% == 0 (echo "port 137-139 have been SHUT DOWN successfully"
echo.)
if %ERRORLEVEL% == 1062 (echo "port 137-139 have been SHUT DOWN successfully"
echo.)


echo "DISABLING port 137-139..."
echo.
sc config netbt start=disabled >nul
if %ERRORLEVEL% == 0 (echo "port 137-139 have been DISABLED successfully"
echo.)

echo "SHUTTING DOWN port 445 IMMEDIATELY..."
echo.
sc stop lanmanserver >nul
if %ERRORLEVEL% == 0 (echo "port 445 has been SHUT DOWN successfully"
echo.)
if %ERRORLEVEL% == 1062 (echo "port 445 has been SHUT DOWN successfully"
echo.)

echo "DISABLING port 445 in regedit..."
echo.
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NetBT\Parameters" /f /v "TransportBindName" /t REG_SZ /d "" >nul
sc config lanmanserver start=disabled >nul
if %ERRORLEVEL% == 0 (echo "port 445 has been DISABLED successfully"
echo.)

echo "DISABLING feature SMB1Protocol with command..."
echo.
dism /online /norestart /disable-feature /featurename:SMB1Protocol >nul
if %ERRORLEVEL% == 0 (echo "feature SMB1Protocol has been disabled"
echo.)
if %ERRORLEVEL% == 3010 (echo "feature SMB1Protocol has been disabled"
echo.)

echo "ADDING value to block SMB1 in regedit (for Windows 7/Sever 2008 / Vista USERS)..."
echo.
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanServer\Parameter" /f /v "SMB1" /t REG_DWORD /d "0" >nul
if %ERRORLEVEL% == 0 (echo "Value has been added in regedit"
echo.)

echo "ADDING value to block SMB2 in regedit (for Windows 7/Sever 2008 / Vista USERS)..."
echo.
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanServer\Parameter" /f /v "SMB2" /t REG_DWORD /d "0" >nul
if %ERRORLEVEL% == 0 (echo "Value has been added in regedit"
echo.)

echo "You are recommended to RESTART your computer now"
echo.
echo "Press any key to RESTART your computer OR close the window to QUIT the program"
pause >nul
shutdown -r -t 0
 exit /b

 :UACPrompt
   echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
   echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

   "%temp%\getadmin.vbs"
   del "%temp%\getadmin.vbs"
  exit /B`
*blocked port 22,23,3389,145,135,137-139,445
*disabled SMBV1 feature
*disable reboot from restart
**created by anonymous_AKXX**