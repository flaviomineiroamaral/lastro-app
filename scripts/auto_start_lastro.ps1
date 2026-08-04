# Script de Autostart: Docker Desktop + Supabase (Lastro Dev)
$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   INICIALIZANDO AMBIENTE LASTRO DEV    " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Verificar e iniciar o Docker Desktop
$dockerProcess = Get-Process "Docker Desktop" -ErrorAction SilentlyContinue
if (-not $dockerProcess) {
    Write-Host "[1/3] Iniciando o Docker Desktop..." -ForegroundColor Yellow
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
} else {
    Write-Host "[1/3] Docker Desktop ja esta em execucao." -ForegroundColor Green
}

# 2. Aguardar o Docker Engine estar completamente pronto
Write-Host "[2/3] Aguardando o Docker Engine ficar pronto..." -ForegroundColor Yellow
$dockerReady = $false
$maxTries = 40
$tryCount = 0

while (-not $dockerReady -and $tryCount -lt $maxTries) {
    $tryCount++
    docker info > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        $dockerReady = $true
    } else {
        Start-Sleep -Seconds 3
        Write-Host "  ...aguardando inicializacao do Docker ($tryCount/$maxTries)" -ForegroundColor Gray
    }
}

if (-not $dockerReady) {
    Write-Host "[ERRO] O Docker Engine nao respondeu a tempo. Verifique se o Docker Desktop abriu corretamente." -ForegroundColor Red
    pause
    exit 1
}

Write-Host "[OK] Docker Engine esta ativo!" -ForegroundColor Green

# 3. Executar o script start_dev.ps1
Write-Host "[3/3] Executando o start_dev.ps1..." -ForegroundColor Yellow
Set-Location "C:\SIGMA\lastro-app"
& "C:\SIGMA\lastro-app\scripts\start_dev.ps1"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AMBIENTE PRONTO! Voce ja pode codar.   " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
