# Script: run_mobile.ps1
# Lança a aplicação Flutter no celular físico conectado via ADB (USB ou Wi-Fi)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Iniciando Lancamento Fisico (Samsung/ADB)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

# 1. Se estiver no USB, descobre o IP do Wi-Fi automaticamente e habilita modo wireless
if (Test-Path $adb) {
    $usbDevice = (& $adb devices | Select-String "device$" | Where-Object { $_ -notmatch ":" } | Select-Object -First 1)
    if ($usbDevice) {
        $devId = ($usbDevice.ToString().Split("`t"))[0].Trim()
        Write-Host "Dispositivo USB detectado ($devId). Atualizando conexao Wi-Fi..." -ForegroundColor Yellow
        $wlanInfo = & $adb -s $devId shell ip addr show wlan0 2>$null | Select-String "inet "
        if ($wlanInfo -match 'inet (\d+\.\d+\.\d+\.\d+)') {
            $deviceIp = $matches[1]
            Write-Host "Novo IP detectado: $deviceIp" -ForegroundColor Green
            & $adb -s $devId tcpip 5555 2>&1 | Out-Null
            Start-Sleep -Seconds 1
            & $adb connect "${deviceIp}:5555" 2>&1 | Out-Null
        }
    } else {
        # Tenta reconectar no ultimo IP conhecido
        Write-Host "Tentando reconexao Wi-Fi ADB (192.168.0.14:5555)..." -ForegroundColor Yellow
        & $adb connect 192.168.0.14:5555 2>&1 | Out-Null
    }
}

# 2. Verifica se existe algum dispositivo detectado
$adbDevices = flutter devices
if ($adbDevices -match "No devices found") {
    Write-Host "[ERRO] Nenhum dispositivo detectado." -ForegroundColor Red
    Write-Host "Verifique se:" -ForegroundColor Yellow
    Write-Host "1. O celular esta na mesma rede Wi-Fi." -ForegroundColor Yellow
    Write-Host "2. Ou conecte o cabo USB no computador." -ForegroundColor Yellow
    Write-Host "3. A Depuracao USB/Wireless esta ativa no celular." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "[OK] Dispositivo(s) ADB detectado(s)." -ForegroundColor Green
Write-Host "Atualizando pacotes..." -ForegroundColor Yellow

Set-Location "C:\SIGMA\lastro-app"
flutter pub get

Write-Host "Compilando e instalando no celular..." -ForegroundColor Yellow
flutter run --android-skip-build-dependency-validation

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Sessao de Teste Encerrada.              " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
pause
