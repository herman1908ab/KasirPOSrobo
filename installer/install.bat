@echo off
chcp 65001 >nul
title Alfamart POS - Installer Lokal
echo ============================================
echo    ALFAMART POS - INSTALLER LOKAL
echo ============================================
echo.

where node >nul 2>nul
if errorlevel 1 (
    echo [X] Node.js belum terpasang!
    echo     Silakan download dan install dari https://nodejs.org
    echo     Lalu jalankan file ini lagi.
    echo.
    pause
    exit /b 1
)
for /f "delims=" %%v in ('node -v') do echo [OK] Node.js %%v terdeteksi.

cd /d "%~dp0..\backend"

if not exist ".env" (
    copy /y ".env.example" ".env" >nul
    echo [OK] File .env dibuat dari contoh.
    echo     Edit backend\.env bila ingin ganti nama toko / password MySQL.
) else (
    echo [OK] File .env sudah ada.
)

if not exist "node_modules" (
    echo [..] Menginstall dependencies - mohon tunggu...
    call npm install --no-audit --no-fund
    if errorlevel 1 goto fail_npm
    echo [OK] Dependencies terinstall.
) else (
    echo [OK] Dependencies sudah terinstall.
)

echo [..] Menyiapkan database MySQL...
node "..\database\setup-db.js"
if errorlevel 1 goto fail_db

echo.
echo ============================================
echo   INSTALLASI SELESAI!
echo   Jalankan start.bat untuk mulai berjualan.
echo ============================================
pause
exit /b 0

:fail_npm
echo.
echo [X] Gagal install dependencies. Periksa koneksi internet lalu ulangi.
echo.
pause
exit /b 1

:fail_db
echo.
echo [X] Gagal setup database.
echo     Pastikan MySQL di XAMPP sudah RUNNING - Apache tidak wajib.
echo     Jika password MySQL bukan kosong, edit DB_PASSWORD di backend\.env
echo.
pause
exit /b 1
