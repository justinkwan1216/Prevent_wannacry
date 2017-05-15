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

echo "DELETING rule to disable port 22 Protocol:TCP"
echo.
netsh advfirewall firewall delete rule name="Block_TCP-22" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 22 on Protocol TCP"
echo.)

echo "DELETING rule to disable port 22 Protocol:UDP"
echo.
netsh advfirewall firewall delete rule name="Block_UDP-22" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 22 on Protocol UDP"
echo.)

echo "DELETING rule to disable port 23 Protocol:TCP"
echo.
netsh advfirewall firewall delete rule name="Block_TCP-23" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 23 on Protocol TCP"
echo.)

echo "DELETING rule to disable port 23 Protocol:UDP"
echo.
netsh advfirewall firewall delete rule name="Block_UDP-23" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 23 on Protocol UDP"
echo.)

echo "DELETING rule to disable port 3389 Protocol:TCP"
echo.
netsh advfirewall firewall delete rule name="Block_TCP-3389" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 3389 on Protocol TCP"
echo.)

echo "DELETING rule to disable port 3389 Protocol:UDP"
echo.
netsh advfirewall firewall delete rule name="Block_UDP-3389" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 3389 on Protocol UDP"
echo.)

echo "DELETING rule to disable port 145 Protocol:TCP"
echo.
netsh advfirewall firewall delete rule name="Block_TCP-145" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 145 on Protocol TCP"
echo.)

echo "DELETING rule to disable port 145 Protocol:UDP"
echo.
netsh advfirewall firewall delete rule name="Block_UDP-145" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 145 on Protocol UDP"
echo.)

echo "DELETING rule to disable port 135 Protocol:TCP"
echo.
netsh advfirewall firewall delete rule name="Block_TCP-135" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 135 on Protocol TCP"
echo.)

echo "DELETING rule to disable port 135 Protocol:UDP"
echo.
netsh advfirewall firewall delete rule name="Block_UDP-135" >nul
if %ERRORLEVEL% == 0 (echo "rule has been deleted to disable port 135 on Protocol UDP"
echo.)

echo "ENABLING port 137-139..."
echo.
sc config netbt start=auto >nul
if %ERRORLEVEL% == 0 (echo "port 137-139 have been ENABLED successfully"
echo.)

echo "TURNING ON port 137-139 IMMEDIATELY..."
echo.
sc start netbt >nul
if %ERRORLEVEL% == 0 (echo "port 137-139 have been TURNED ON successfully"
echo.)
if %ERRORLEVEL% == 1062 (echo "port 137-139 have been TURNED ON successfully"
echo.)

echo "ENABLING port 445 in regedit..."
echo.
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NetBT\Parameters" /f /v "TransportBindName" /t REG_SZ /d "\DEVICE" >nul
sc config lanmanserver start=auto >nul
if %ERRORLEVEL% == 0 (echo "port 445 has been ENABLED successfully"
echo.)

echo "TURNING ON port 445 IMMEDIATELY..."
echo.
sc start lanmanserver >nul
if %ERRORLEVEL% == 0 (echo "port 445 has been TURNED ON successfully"
echo.)
if %ERRORLEVEL% == 1062 (echo "port 445 has been TURNED ON successfully"
echo.)


echo "ENABLING feature SMB1Protocol with command..."
echo.
dism /online /norestart /enable-feature /featurename:SMB1Protocol >nul
if %ERRORLEVEL% == 0 (echo "feature SMB1Protocol has been enabled"
echo.)
if %ERRORLEVEL% == 3010 (echo "feature SMB1Protocol has been enabled"
echo.)

echo "DELETING value to block SMB1 in regedit (for Windows 7/Sever 2008 / Vista USERS)..."
echo.
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanServer\Parameter" /f /v "SMB1" /t REG_DWORD /d "1" >nul
if %ERRORLEVEL% == 0 (echo "Value has been deleted in regedit"
echo.)

echo "DELETING value to block SMB2 in regedit (for Windows 7/Sever 2008 / Vista USERS)..."
echo.
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanServer\Parameter" /f /v "SMB2" /t REG_DWORD /d "1" >nul
if %ERRORLEVEL% == 0 (echo "Value has been deleted in regedit"
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
*enable port 22,23,3389,145,135,137-139,445
*enable SMBV1 feature
**created by anonymous_AKXX**