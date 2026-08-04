# Script: create_migration.ps1
# Assistente que pergunta o nome da migracao, roda o diff no Supabase e abre no VS Code.

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Assistente de Migracao - Supabase       " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$migrationName = Read-Host "Digite um nome curto e descritivo para a migracao (ex: cria_tabela_usuarios)"

if ([string]::IsNullOrWhiteSpace($migrationName)) {
    Write-Host "[ERRO] O nome da migracao nao pode ser vazio." -ForegroundColor Red
    pause
    exit 1
}

# Remove espacos e caracteres invalidos, trocando por underscore
$safeName = $migrationName -replace '[^a-zA-Z0-9]', '_' -replace '_+', '_'

Write-Host "Gerando migracao: $safeName..." -ForegroundColor Yellow

Set-Location "C:\SIGMA\lastro-app"
npx supabase db diff -f $safeName

Write-Host "[OK] Migracao gerada com sucesso na pasta supabase/migrations!" -ForegroundColor Green
Write-Host "Tentando abrir no VS Code para revisao..." -ForegroundColor Yellow

# Tenta abrir a pasta de migrations no VS Code
try {
    code "C:\SIGMA\lastro-app\supabase\migrations"
} catch {
    Write-Host "[INFO] O comando 'code' nao esta no PATH ou o VS Code nao esta instalado." -ForegroundColor Gray
}

Write-Host "Processo concluido." -ForegroundColor Cyan
pause
