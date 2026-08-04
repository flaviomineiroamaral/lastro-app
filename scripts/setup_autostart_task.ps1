# Script para registrar a Inicializacao Automatica no Windows
$scriptPath = "C:\SIGMA\lastro-app\scripts\auto_start_lastro.ps1"
$taskName = "LastroAutoStartDev"

# 1. Registrar no Agendador de Tarefas do Windows
try {
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoExit -ExecutionPolicy Bypass -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Description 'Inicia Docker Desktop e ambiente Lastro Dev ao ligar o PC' -Force | Out-Null
    Write-Host "[OK] Tarefa Agendada '$taskName' criada no Windows com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "[AVISO] Nao foi possivel criar no Agendador de Tarefas: $_" -ForegroundColor Yellow
}

# 2. Criar Atalho na pasta Inicializar (Startup Folder) para abrir a janela visivelmente ao fazer login
$startupFolder = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup')
$shortcutPath = [System.IO.Path]::Combine($startupFolder, 'LastroAutoStart.lnk')

$wos = New-Object -ComObject WScript.Shell
$shortcut = $wos.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoExit -ExecutionPolicy Bypass -File `"$scriptPath`""
$shortcut.WorkingDirectory = "C:\SIGMA\lastro-app"
$shortcut.WindowStyle = 1
$shortcut.IconLocation = "powershell.exe,0"
$shortcut.Save()

Write-Host "[OK] Atalho de Inicializacao criado em: $shortcutPath" -ForegroundColor Green
