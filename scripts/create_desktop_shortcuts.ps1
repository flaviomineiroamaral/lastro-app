# Script para criar pasta de atalhos na Area de Trabalho do Usuario
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, 'Desktop')
$targetFolder = [System.IO.Path]::Combine($desktopPath, 'Lastro App - Ferramentas')

if (-not (Test-Path $targetFolder)) {
    New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
}

$wos = New-Object -ComObject WScript.Shell

# 1. Atalho: Iniciar Ambiente
$sc1 = $wos.CreateShortcut("$targetFolder\1 - Iniciar Ambiente.lnk")
$sc1.TargetPath = "powershell.exe"
$sc1.Arguments = "-NoExit -ExecutionPolicy Bypass -File C:\SIGMA\lastro-app\scripts\start_dev.ps1"
$sc1.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc1.IconLocation = "powershell.exe,0"
$sc1.Save()

# 2. Atalho: Aplicar Patch Android (FlutterFlow)
$sc2 = $wos.CreateShortcut("$targetFolder\2 - Aplicar Patch Android (FlutterFlow).lnk")
$sc2.TargetPath = "powershell.exe"
$sc2.Arguments = "-NoExit -ExecutionPolicy Bypass -File C:\SIGMA\lastro-app\scripts\patch_android.ps1"
$sc2.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc2.IconLocation = "cmd.exe,0"
$sc2.Save()

# 3. Atalho: Encerrar Expediente
$sc3 = $wos.CreateShortcut("$targetFolder\3 - Encerrar Expediente (Deploy Staging).lnk")
$sc3.TargetPath = "powershell.exe"
$sc3.Arguments = "-NoExit -ExecutionPolicy Bypass -File C:\SIGMA\lastro-app\scripts\finish_day.ps1"
$sc3.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc3.IconLocation = "powershell.exe,0"
$sc3.Save()

# 4. Atalho de URL: Supabase Studio Local
$urlContent = "[InternetShortcut]`r`nURL=http://127.0.0.1:54323`r`nIconIndex=0`r`nIconFile=C:\Windows\System32\shell32.dll"
Set-Content -Path "$targetFolder\4 - Abrir Supabase Studio (Local).url" -Value $urlContent

# 5. Atalho: Abrir Pasta do Projeto
$sc5 = $wos.CreateShortcut("$targetFolder\5 - Abrir Pasta do Projeto (Explorer).lnk")
$sc5.TargetPath = "explorer.exe"
$sc5.Arguments = "C:\SIGMA\lastro-app"
$sc5.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc5.Save()

# 6. Atalho: Sincronizar FlutterFlow
$sc6 = $wos.CreateShortcut("$targetFolder\6 - [Avancado] Sincronizar FlutterFlow.lnk")
$sc6.TargetPath = "powershell.exe"
$sc6.Arguments = "-NoExit -ExecutionPolicy Bypass -File C:\SIGMA\lastro-app\scripts\sync_flutterflow.ps1"
$sc6.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc6.IconLocation = "powershell.exe,0"
$sc6.Save()

# 7. Atalho: Assistente de Migracao
$sc7 = $wos.CreateShortcut("$targetFolder\7 - [Avancado] Assistente de Migracao.lnk")
$sc7.TargetPath = "powershell.exe"
$sc7.Arguments = "-NoExit -ExecutionPolicy Bypass -File C:\SIGMA\lastro-app\scripts\create_migration.ps1"
$sc7.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc7.IconLocation = "powershell.exe,0"
$sc7.Save()

# 8. Atalho: Lançar no Celular
$sc8 = $wos.CreateShortcut("$targetFolder\8 - [Avancado] Lançar no Celular Físico.lnk")
$sc8.TargetPath = "powershell.exe"
$sc8.Arguments = "-NoExit -ExecutionPolicy Bypass -File C:\SIGMA\lastro-app\scripts\run_mobile.ps1"
$sc8.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc8.IconLocation = "powershell.exe,0"
$sc8.Save()

# 9. Atalho: Manual (README.md)
$sc9 = $wos.CreateShortcut("$targetFolder\Manual do Lastro App.lnk")
$sc9.TargetPath = "C:\SIGMA\lastro-app\README.md"
$sc9.WorkingDirectory = "C:\SIGMA\lastro-app"
$sc9.Save()

Write-Host "[OK] Pasta e atalhos atualizados com sucesso na Area de Trabalho!" -ForegroundColor Green
Write-Host "Caminho: $targetFolder" -ForegroundColor Cyan
