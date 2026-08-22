@echo off
chcp 65001 >nul
title Alfamart POS - Server Kasir
cd /d "%~dp0backend"

where node >nul 2>nul
if errorlevel 1 (
    echo [X] Node.js belum terpasang!
    echo     Jalankan install.bat terlebih dahulu.
    echo.
    pause
    exit /b 1
)

echo ============================================
echo    ALFAMART POS - SERVER KASIR
echo ============================================
echo.
echo Server akan berjalan dan browser akan terbuka otomatis.
echo Biarkan jendela ini TERBUKA selama berjualan.
echo Tekan Ctrl+C untuk mematikan server.
echo.
echo Pastikan MySQL di XAMPP sudah RUNNING ya!
echo.
pause

call npm start

echo.
echo Server dimatikan. Terima kasih!
pause
