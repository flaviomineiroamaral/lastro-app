# Script: sync_flutterflow.ps1
# Sincroniza o codigo do FlutterFlow usando a CLI oficial, extrai e aplica o patch do Android automaticamente.

$ErrorActionPreference = "Stop"

# Substitua com o Project ID e Token obtidos no painel do FlutterFlow
$PROJECT_ID = "lastro-sigma-sistemas-u5hi20"
$API_TOKEN = "757151a4-0289-4656-984a-0e9e45d9fb6a"
$DESTINATION = "C:\SIGMA\lastro-app\lastro_sigma_sistemas"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Sincronizacao Automatica FlutterFlow CLI " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

if ($API_TOKEN -eq "SEU_API_TOKEN_AQUI") {
    Write-Host "[ALERTA] Voce precisa configurar o SEU_API_TOKEN_AQUI dentro deste script (scripts/sync_flutterflow.ps1) para funcionar!" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Baixando codigo do projeto: $PROJECT_ID..." -ForegroundColor Yellow
# O comando abaixo requer que o flutterflow-cli esteja instalado (`dart pub global activate flutterflow_cli`)
flutterflow export-code --project $PROJECT_ID --dest $DESTINATION --token $API_TOKEN

Write-Host "[OK] Codigo baixado com sucesso!" -ForegroundColor Green

Write-Host "Iniciando Patch de Infraestrutura do Android..." -ForegroundColor Yellow
& "C:\SIGMA\lastro-app\scripts\patch_android.ps1"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Processo de Atualizacao Concluido!      " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
