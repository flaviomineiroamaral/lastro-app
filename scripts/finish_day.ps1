# Script de Encerramento do Expediente
param (
    [string]$CommitMessage = "feat: atualizacoes do dia no Lastro"
)

Set-Location "C:\SIGMA\lastro-app"

Write-Host "=== ENCERRANDO EXPEDIENTE LASTRO ===" -ForegroundColor Cyan

# 1. Status do Git
Write-Host "Verificando alterações..." -ForegroundColor Yellow
git status

# 2. Add e Commit
Write-Host "Adicionando alterações e realizando commit..." -ForegroundColor Yellow
git add .
git commit -m "$CommitMessage"

# 3. Push para a Main (Aciona CI/CD Staging automaticamente!)
Write-Host "Enviando alterações para o GitHub (CI/CD Staging)..." -ForegroundColor Yellow
git push origin main

# 4. Parar Supabase Local
Write-Host "Parando microsserviços do Supabase..." -ForegroundColor Yellow
npx supabase stop

Write-Host "=== EXPEDIENTE ENCERRADO COM SUCESSO! ===" -ForegroundColor Green
