# Script: create_migration.ps1
# Assistente que pergunta o nome da migração, roda o diff no Supabase e abre no VS Code.

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Assistente de Migração - Supabase       " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$migrationName = Read-Host "Digite um nome curto e descritivo para a migração (ex: cria_tabela_usuarios)"

if ([string]::IsNullOrWhiteSpace($migrationName)) {
    Write-Host "[ERRO] O nome da migração não pode ser vazio." -ForegroundColor Red
    pause
    exit 1
}

# Remove espaços e caracteres inválidos, trocando por underscore
$safeName = $migrationName -replace '[^a-zA-Z0-9]', '_' -replace '_+', '_'

Write-Host "Gerando migração: $safeName..." -ForegroundColor Yellow

Set-Location "C:\SIGMA\lastro-app"
npx supabase db diff -f $safeName

Write-Host "[OK] Migração gerada com sucesso na pasta supabase/migrations!" -ForegroundColor Green
Write-Host "Tentando abrir no VS Code para revisão..." -ForegroundColor Yellow

# Tenta abrir a pasta de migrations no VS Code
try {
    code "C:\SIGMA\lastro-app\supabase\migrations"
} catch {
    Write-Host "[INFO] O comando 'code' não está no PATH ou o VS Code não está instalado." -ForegroundColor Gray
}

Write-Host "Processo concluído." -ForegroundColor Cyan
pause
