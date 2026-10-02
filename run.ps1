$env:PATH = "$env:LOCALAPPDATA\Programs\nodejs;$env:PATH"
Set-Location "$PSScriptRoot"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Starting Real-Time Voice Translator (No MongoDB required!)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Frontend : http://localhost:5173" -ForegroundColor Yellow
Write-Host "  Backend  : http://localhost:5000" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
npm run dev