@echo off
chcp 65001 >nul
title Buat Shortcut Desktop HerMart POS
echo ============================================
echo   MEMBUAT SHORTCUT DESKTOP HERMART POS
echo ============================================
echo.

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\HerMart POS.lnk'); $Shortcut.TargetPath = '%~dp0start-all.bat'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.Save()"

if errorlevel 1 (
    echo [X] Gagal membuat shortcut.
) else (
    echo [OK] Shortcut "HerMart POS" berhasil dibuat di Desktop!
)
echo.
pause
