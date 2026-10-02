@echo off
set "PATH=%LOCALAPPDATA%\Programs\nodejs;%PATH%"
cd /d "%~dp0"
echo ============================================================
echo   Starting Real-Time Voice Translator (No MongoDB required!)
echo ============================================================
echo   Frontend : http://localhost:5173
echo   Backend  : http://localhost:5000
echo ============================================================
npm run dev
pause