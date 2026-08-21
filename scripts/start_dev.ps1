# Script de Inicialização do Ambiente (Cloud-First)
Set-Location "C:\SIGMA\lastro-app"

Write-Host "=== INICIANDO AMBIENTE LASTRO (CLOUD) ===" -ForegroundColor Cyan

# 1. Baixar atualizações do Git
Write-Host "Sincronizando com o GitHub..." -ForegroundColor Yellow
git pull origin main

Write-Host "`n=== AMBIENTE PRONTO PARA USO! ===" -ForegroundColor Green
Write-Host "Backend: Supabase Cloud (Nuvem Oficial)" -ForegroundColor Cyan
Write-Host "CI/CD: GitHub Actions ativo" -ForegroundColor Cyan

