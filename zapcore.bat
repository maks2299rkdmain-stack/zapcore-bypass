@echo off
title ZAPCORE

:check_admin
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Run as Administrator.
    pause
    exit /b 1
)

:: Создаём папку WinDivert если её нет
if not exist "%~dp0WinDivert\WinDivert.exe" goto install_deps

set PATH=%~dp0WinDivert;%PATH%
goto menu

:install_deps
cls
echo.
echo =====================================================================
echo.
echo     ███████╗ █████╗ ██████╗  ██████╗ ██████╗ ██████╗ ███████╗
echo     ╚══███╔╝██╔══██╗██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝
echo       ███╔╝ ███████║██████╔╝██║     ██║   ██║██████╔╝█████╗  
echo      ███╔╝  ██╔══██║██╔═══╝ ██║     ██║   ██║██╔══██╗██╔══╝  
echo     ███████╗██║  ██║██║     ╚██████╗╚██████╔╝██║  ██║███████╗
echo     ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
echo.
echo =====================================================================
echo.
echo                 ZAPCORE - FIRST TIME SETUP
echo =====================================================================
echo.
echo [ZAPCORE] Downloading WinDivert...
mkdir "%~dp0WinDivert" 2>nul
cd /d "%~dp0WinDivert"

:: Скачивание WinDivert
curl -L -o WinDivert.zip https://github.com/basil00/Divert/releases/download/v2.2.2/WinDivert-2.2.2-x64.zip
if errorlevel 1 (
    echo [ERROR] curl failed. Download manually:
    echo https://github.com/basil00/Divert/releases/download/v2.2.2/WinDivert-2.2.2-x64.zip
    echo Extract to %~dp0WinDivert
    pause
    exit /b 1
)

:: Распаковка
tar -xf WinDivert.zip 2>nul
copy "WinDivert-2.2.2-x64\WinDivert64.sys" . 2>nul
copy "WinDivert-2.2.2-x64\WinDivert.dll" . 2>nul
copy "WinDivert-2.2.2-x64\WinDivert.exe" . 2>nul
del WinDivert.zip 2>nul
rmdir "WinDivert-2.2.2-x64" 2>nul

echo [ZAPCORE] Installation complete!
ping -n 2 127.0.0.1 >nul
goto menu

:menu
cls
set PATH=%~dp0WinDivert;%PATH%
echo.
echo =====================================================================
echo.
echo     ███████╗ █████╗ ██████╗  ██████╗ ██████╗ ██████╗ ███████╗
echo     ╚══███╔╝██╔══██╗██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝
echo       ███╔╝ ███████║██████╔╝██║     ██║   ██║██████╔╝█████╗  
echo      ███╔╝  ██╔══██║██╔═══╝ ██║     ██║   ██║██╔══██╗██╔══╝  
echo     ███████╗██║  ██║██║     ╚██████╗╚██████╔╝██║  ██║███████╗
echo     ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
echo.
echo =====================================================================
echo.
echo                     ZAPCORE - ANTI-DPI ENGINE
echo.
echo =====================================================================
echo.
echo    [1]  START - SYN + TTL SPOOF
echo    [2]  START - FRAGMENT MODE (MTU 128)
echo    [3]  START - FRAGMENT MODE (MTU 1400)
echo    [4]  START - FULL BYPASS
echo    [5]  START - TURBO MODE (mtu 256 + ttl 1)
echo    [6]  START - STEALTH MODE (ttl 64)
echo    [7]  START - ICMP BYPASS
echo    [8]  START - UDP MODE
echo    [9]  REINSTALL WinDivert
echo    [0]  EXIT
echo.
echo =====================================================================
echo.
set /p choice="SELECT [0-9]: "

if "%choice%"=="1" goto start_syn
if "%choice%"=="2" goto start_frag128
if "%choice%"=="3" goto start_frag1400
if "%choice%"=="4" goto start_full
if "%choice%"=="5" goto start_turbo
if "%choice%"=="6" goto start_stealth
if "%choice%"=="7" goto start_icmp
if "%choice%"=="8" goto start_udp
if "%choice%"=="9" goto reinstall
if "%choice%"=="0" exit
goto menu

:reinstall
echo [ZAPCORE] Reinstalling WinDivert...
rmdir /s /q "%~dp0WinDivert" 2>nul
goto install_deps

:start_syn
cls
echo [ZAPCORE] MODE: SYN + TTL SPOOF
"%~dp0WinDivert\WinDivert.exe" filter "outbound and tcp and tcp.Syn" send-only dummy ttl 42 recalc-checksum
pause
goto menu

:start_frag128
cls
echo [ZAPCORE] MODE: FRAGMENT MTU 128
"%~dp0WinDivert\WinDivert.exe" filter "outbound and tcp" send-only mtu 128 recalc-checksum
pause
goto menu

:start_frag1400
cls
echo [ZAPCORE] MODE: FRAGMENT MTU 1400
"%~dp0WinDivert\WinDivert.exe" filter "outbound and tcp" send-only mtu 1400 recalc-checksum
pause
goto menu

:start_full
cls
echo [ZAPCORE] MODE: FULL BYPASS
start "ZAPCORE" "%~dp0WinDivert\WinDivert.exe" filter "outbound and tcp" send-only dummy ttl 42 mtu 128 recalc-checksum
echo [ZAPCORE] Running in background.
echo [ZAPCORE] Close this window to stop.
pause
goto menu

:start_turbo
cls
echo [ZAPCORE] MODE: TURBO (mtu 256 + ttl 1)
"%~dp0WinDivert\WinDivert.exe" filter "outbound and tcp" send-only dummy ttl 1 mtu 256 recalc-checksum
pause
goto menu

:start_stealth
cls
echo [ZAPCORE] MODE: STEALTH (ttl 64)
"%~dp0WinDivert\WinDivert.exe" filter "outbound and tcp" send-only dummy ttl 64 recalc-checksum
pause
goto menu

:start_icmp
cls
echo [ZAPCORE] MODE: ICMP BYPASS
"%~dp0WinDivert\WinDivert.exe" filter "outbound and icmp" send-only dummy ttl 42 recalc-checksum
pause
goto menu

:start_udp
cls
echo [ZAPCORE] MODE: UDP
"%~dp0WinDivert\WinDivert.exe" filter "outbound and udp" send-only dummy ttl 42 recalc-checksum
pause
goto menu