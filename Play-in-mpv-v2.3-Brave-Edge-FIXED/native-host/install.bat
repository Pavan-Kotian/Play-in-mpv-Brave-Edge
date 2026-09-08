@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Play in mpv - Brave + Edge v2.3 FIXED

echo.
echo ==================================================
echo       Play in mpv - Brave + Edge v2.3 FIXED
echo ==================================================
echo.
echo This installer creates ONE native-host manifest.
echo It automatically removes duplicate extension IDs.
echo.

set /p BRAVEID=Paste your Brave Extension ID: 
if "%BRAVEID%"=="" (
  echo ERROR: Brave Extension ID cannot be empty.
  pause
  exit /b 1
)

set /p EDGEID=Paste your Edge Extension ID: 
if "%EDGEID%"=="" (
  echo ERROR: Edge Extension ID cannot be empty.
  pause
  exit /b 1
)

set "HOSTDIR=%~dp0"
set "MANIFEST=%HOSTDIR%com.pavan.mpv.json"
set "BATFILE=%HOSTDIR%mpv-host.bat"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ids=@($env:BRAVEID,$env:EDGEID) | ForEach-Object { $_.Trim() } | Where-Object { $_ } | Select-Object -Unique; $origins=@($ids | ForEach-Object { 'chrome-extension://' + $_ + '/' }); $m=@{name='com.pavan.mpv'; description='Launch mpv from Brave and Edge'; path=$env:BATFILE; type='stdio'; allowed_origins=$origins} | ConvertTo-Json -Depth 5; [IO.File]::WriteAllText($env:MANIFEST,$m,(New-Object Text.UTF8Encoding($false)))"

if not exist "%MANIFEST%" (
  echo ERROR: Failed to create manifest.
  pause
  exit /b 1
)

echo.
echo Created manifest:
echo %MANIFEST%
echo.
type "%MANIFEST%"

echo.
echo Registering native host for Brave...
reg add "HKCU\Software\BraveSoftware\Brave-Browser\NativeMessagingHosts\com.pavan.mpv" /ve /t REG_SZ /d "%MANIFEST%" /f

echo Registering native host for Edge...
reg add "HKCU\Software\Microsoft\Edge\NativeMessagingHosts\com.pavan.mpv" /ve /t REG_SZ /d "%MANIFEST%" /f

echo.
echo ==================================================
echo Setup complete.
echo ==================================================
echo.
echo IMPORTANT FOR BRAVE:
echo If Brave reports "Access to the specified native messaging host is forbidden":
echo 1. Remove the old extension from brave://extensions
echo 2. Fully close Brave.
echo 3. Reopen Brave and Load unpacked from this package's extension folder.
echo 4. Verify chrome.runtime.id and run this installer again if it changed.
echo.
pause