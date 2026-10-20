# Script para gerar o pacote oficial (.aab) para publicação na Google Play Store
$ErrorActionPreference = "Stop"
Set-Location "C:\SIGMA\lastro-app"

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "  GERANDO PACOTE OFICIAL GOOGLE PLAY (.AAB - PRODUÇÃO)   " -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

Write-Host "1. Atualizando dependências..." -ForegroundColor Yellow
flutter pub get

Write-Host "2. Compilando Android App Bundle (.aab) assinado em modo Release (Banco: Produção)..." -ForegroundColor Yellow
flutter build appbundle --release --dart-define=SUPABASE_ENV=producao

$aabSource = "C:\SIGMA\lastro-app\build\app\outputs\bundle\release\app-release.aab"
$aabDest = "C:\SIGMA\lastro-app\keystore_backup\Lastro_GooglePlay.aab"

if (Test-Path $aabSource) {
    Copy-Item $aabSource $aabDest -Force
    Write-Host "`n[SUCESSO] Pacote Google Play (.aab) gerado e assinado com sucesso!" -ForegroundColor Green
    Write-Host "Caminho 1: $aabSource" -ForegroundColor Cyan
    Write-Host "Caminho 2 (Cópia fácil): $aabDest" -ForegroundColor Cyan
} else {
    Write-Host "`n[ERRO] O arquivo .aab não foi encontrado." -ForegroundColor Red
    exit 1
}
