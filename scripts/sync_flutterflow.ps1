Set-Location "C:\SIGMA\lastro-app"
Write-Host "=== SINCRONIZANDO REPOSITORIO COM O GITHUB ===" -ForegroundColor Cyan

Write-Host "Buscando atualizacoes do FlutterFlow no GitHub..." -ForegroundColor Yellow
git fetch origin
git pull origin main

Write-Host "`n[OK] Repositorio local atualizado com sucesso!" -ForegroundColor Green
