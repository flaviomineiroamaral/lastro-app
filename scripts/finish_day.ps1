# Script de Encerramento do Expediente
param (
    [string]$CommitMessage = "feat: atualizacoes do dia no Lastro"
)

Set-Location "C:\SIGMA\lastro-app"

Write-Host "=== ENCERRANDO EXPEDIENTE LASTRO ===" -ForegroundColor Cyan

# 1. Status do Git
Write-Host "Verificando alteracoes..." -ForegroundColor Yellow
git status -s

# 2. Add e Commit
Write-Host "Adicionando alteracoes e realizando commit..." -ForegroundColor Yellow
git add .
git commit -m "$CommitMessage"

# 3. Push para a Main (Aciona CI/CD e Build do APK na nuvem)
Write-Host "Enviando alteracoes para o GitHub (Disparando CI/CD e Build APK)..." -ForegroundColor Yellow
git push origin main

Write-Host "`n=== EXPEDIENTE ENCERRADO COM SUCESSO! ===" -ForegroundColor Green
Write-Host "As esteiras de CI/CD e Build estao rodando no GitHub Actions." -ForegroundColor Cyan

