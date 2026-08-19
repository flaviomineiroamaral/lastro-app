# Script de Inicialização do Ambiente Matinal
Set-Location "C:\SIGMA\lastro-app"

Write-Host "=== INICIANDO AMBIENTE LASTRO ===" -ForegroundColor Cyan

# 1. Baixar atualizações do Git
Write-Host "Sincronizando com o GitHub..." -ForegroundColor Yellow
git pull origin main

# 2. Iniciar Supabase Local
Write-Host "Iniciando microsserviços do Supabase local..." -ForegroundColor Yellow
npx supabase start

Write-Host "=== AMBIENTE PRONTO PARA USO! ===" -ForegroundColor Green
Write-Host "Studio Local: http://127.0.0.1:54323" -ForegroundColor Cyan
