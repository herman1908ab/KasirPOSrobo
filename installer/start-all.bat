@echo off
chcp 65001 >nul
title HerMart POS - Sistem Kasir ROBOKOMPUTER
echo ============================================
echo    HERMART POS - LAUNCHER UTAMA
echo ============================================
echo.

echo [1/3] Menyalakan XAMPP (Apache ^& MySQL)...
if exist "C:\xampp\mysql_start.bat" (
    start /min "" "C:\xampp\mysql_start.bat"
) else (
    net start mysql >nul 2>&1
)

if exist "C:\xampp\apache_start.bat" (
    start /min "" "C:\xampp\apache_start.bat"
) else (
    net start Apache2.4 >nul 2>&1
)
echo [OK] Perintah XAMPP dikirim.

echo.
echo [2/3] Menyiapkan browser ke http://localhost:4000 ...
timeout /t 3 /nobreak >nul
start http://localhost:4000

echo.
echo [3/3] Menjalankan Server POS (Node.js)...
echo --------------------------------------------
echo Biarkan jendela ini tetap TERBUKA selama kasir aktif.
echo Untuk mematikan server, tutup jendela ini atau tekan Ctrl+C.
echo --------------------------------------------
echo.

cd /d "%~dp0..\backend"
call npm start

echo.
echo Server telah dimatikan.
pause
