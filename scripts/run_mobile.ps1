# Script: run_mobile.ps1
# Lanca a aplicacao Flutter no celular fisico conectado via ADB

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Iniciando Lancamento Fisico (Samsung/ADB)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Verifica se existe algum dispositivo listado pelo ADB
$adbDevices = flutter devices
if ($adbDevices -match "No devices found") {
    Write-Host "[ERRO] Nenhum dispositivo detectado." -ForegroundColor Red
    Write-Host "Verifique se:" -ForegroundColor Yellow
    Write-Host "1. O cabo USB esta conectado." -ForegroundColor Yellow
    Write-Host "2. A Depuracao USB esta ativa no aparelho." -ForegroundColor Yellow
    Write-Host "3. O driver da Samsung esta instalado." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "[OK] Dispositivo(s) ADB detectado(s)." -ForegroundColor Green
Write-Host "Limpando cache de build e atualizando pacotes..." -ForegroundColor Yellow

Set-Location "C:\SIGMA\lastro-app\lastro_sigma_sistemas"
flutter clean
flutter pub get

Write-Host "Compilando e instalando no celular..." -ForegroundColor Yellow
flutter run

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Sessao de Teste Encerrada.              " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
pause
