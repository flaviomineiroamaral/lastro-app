# =============================================================================
# Script: sync_flutterflow.ps1
# Sincroniza o codigo do FlutterFlow e re-aplica automaticamente todas as
# customizacoes do Lastro (Share Intent, OFX inteligente, patches de infra).
#
# ORDEM DE EXECUCAO:
#   1. Backup dos arquivos customizados (nao gerenciados pelo FlutterFlow)
#   2. Download do projeto via FlutterFlow CLI
#   3. Limpeza de pasta aninhada (bug historico do FF CLI)
#   4. Restore dos arquivos customizados
#   5. Patches Android + flutter pub get + flutter analyze
# =============================================================================

$ErrorActionPreference = "Stop"

# --- CONFIGURACAO ---------------------------------------------------------
$PROJECT_ID   = "lastro-sigma-sistemas-u5hi20"
$API_TOKEN    = "757151a4-0289-4656-984a-0e9e45d9fb6a"
$DESTINATION  = "C:\SIGMA\lastro-app"           # PAI do projeto (FF CLI cria subpasta)
$PROJECT_ROOT = "C:\SIGMA\lastro-app\lastro_sigma_sistemas"
$BACKUP_DIR   = "C:\SIGMA\lastro-app\.lastro_custom_backup"
$SCRIPTS_DIR  = "C:\SIGMA\lastro-app\scripts"
$FF_CLI       = "$env:USERPROFILE\AppData\Local\Pub\Cache\bin\flutterflow.bat"

# --------------------------------------------------------------------------
# LISTA DE ARQUIVOS CUSTOMIZADOS
# Arquivos criados/modificados FORA do FlutterFlow que devem ser preservados
# a cada sync. Adicione novos arquivos aqui conforme necessario.
# --------------------------------------------------------------------------
$CUSTOM_FILES = @(
    # --- Share Intent (recebimento de arquivos do app do banco) ---
    "lib\lastro\importacao\action\receber_arquivo_compartilhado.dart",

    # --- Conciliacao Inteligente OFX (IA de categorizacao) ---
    "lib\lastro\importacao\action\salvar_regras_aprendidas.dart",
    "lib\lastro\importacao\action\sugerir_categoria_ofx.dart",

    # --- Struct OFX estendido com campos de IA ---
    "lib\backend\schema\structs\ofx_transaction_struct.dart",

    # --- Widget de selecao de transacoes (refatorado) ---
    "lib\lastro\importacao\selecionar_transacoes\selecionar_transacoes_widget.dart",

    # --- Plataforma: Android (Share Intent filters no Manifest) ---
    "android\app\src\main\AndroidManifest.xml",

    # --- Plataforma: iOS (CFBundleDocumentTypes no Info.plist) ---
    "ios\Runner\Info.plist",

    # --- Config: analise Dart (exclui pasta aninhada, custom code) ---
    "analysis_options.yaml",

    # --- Config: dependencias (inclui receive_sharing_intent e outros) ---
    "pubspec.yaml"
)

# =============================================================================
# HELPERS
# =============================================================================
function Write-Banner($msg, $color = "Cyan") {
    Write-Host ""
    Write-Host ("=" * 55) -ForegroundColor $color
    Write-Host "  $msg" -ForegroundColor $color
    Write-Host ("=" * 55) -ForegroundColor $color
}

function Write-Step($num, $total, $msg) {
    Write-Host ""
    Write-Host "  [$num/$total] $msg" -ForegroundColor Yellow
}

function Write-OK($msg)  { Write-Host "        [OK] $msg" -ForegroundColor Green }
function Write-SKIP($msg){ Write-Host "      [SKIP] $msg" -ForegroundColor DarkYellow }
function Write-ERR($msg) { Write-Host "      [ERRO] $msg" -ForegroundColor Red }

# =============================================================================
# INICIO
# =============================================================================
Write-Banner "SYNC FLUTTERFLOW - LASTRO SIGMA SISTEMAS"

if ($API_TOKEN -eq "SEU_API_TOKEN_AQUI") {
    Write-ERR "Configure o API_TOKEN dentro do script sync_flutterflow.ps1!"
    exit 1
}

if (-not (Test-Path $FF_CLI)) {
    Write-ERR "FlutterFlow CLI nao encontrado em: $FF_CLI"
    Write-ERR "Instale com:  dart pub global activate flutterflow_cli"
    exit 1
}

$errosFinais = 0

# =============================================================================
# PASSO 1 — BACKUP dos arquivos customizados
# =============================================================================
Write-Step 1 5 "Backup dos arquivos customizados do Lastro..."

if (Test-Path $BACKUP_DIR) {
    Remove-Item -Recurse -Force $BACKUP_DIR
}
New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null

$backed = 0
foreach ($relPath in $CUSTOM_FILES) {
    $source = Join-Path $PROJECT_ROOT $relPath
    $dest   = Join-Path $BACKUP_DIR   $relPath
    if (Test-Path $source) {
        $destDir = Split-Path $dest -Parent
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        Copy-Item $source $dest -Force
        Write-OK "Backup: $relPath"
        $backed++
    } else {
        Write-SKIP "Nao existe ainda (sera criado apos sync): $relPath"
    }
}
Write-OK "$backed arquivo(s) em backup em: $BACKUP_DIR"

# =============================================================================
# PASSO 2 — DOWNLOAD do FlutterFlow
# =============================================================================
Write-Step 2 5 "Baixando codigo do projeto '$PROJECT_ID' do FlutterFlow..."

try {
    & $FF_CLI export-code --project $PROJECT_ID --dest $DESTINATION --token $API_TOKEN
    Write-OK "Codigo FlutterFlow baixado com sucesso!"
} catch {
    Write-ERR "Falha no download do FlutterFlow: $_"
    # Restaura backup antes de sair para nao deixar o projeto corrompido
    Write-Host "  Restaurando backup emergencial..." -ForegroundColor Red
    foreach ($relPath in $CUSTOM_FILES) {
        $source = Join-Path $BACKUP_DIR $relPath
        $dest   = Join-Path $PROJECT_ROOT $relPath
        if (Test-Path $source) {
            $destDir = Split-Path $dest -Parent
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            Copy-Item $source $dest -Force
        }
    }
    exit 1
}

# =============================================================================
# PASSO 3 — LIMPEZA de pasta aninhada (bug historico do FF CLI)
# O FlutterFlow CLI cria uma subpasta com o nome do projeto dentro do --dest.
# Se --dest ja era a pasta do projeto, havera aninhamento. Este passo detecta
# e remove automaticamente qualquer residuo.
# =============================================================================
Write-Step 3 5 "Verificando integridade da estrutura de pastas..."

$NESTED_PATH = Join-Path $PROJECT_ROOT "lastro_sigma_sistemas"
if (Test-Path $NESTED_PATH) {
    Remove-Item -Recurse -Force $NESTED_PATH
    Write-OK "Pasta aninhada detectada e removida: $NESTED_PATH"
    Write-Host "        DICA: Isso indica que o --dest estava errado em alguma execucao anterior." -ForegroundColor DarkYellow
} else {
    Write-OK "Estrutura OK - nenhuma pasta aninhada encontrada."
}

# Verifica outras possiveis pastas duplicadas com nome do projeto
Get-ChildItem -Path $PROJECT_ROOT -Directory | Where-Object {
    $_.Name -like "lastro*" -or $_.Name -like "sigma*"
} | ForEach-Object {
    Write-Host "  [AVISO] Pasta suspeita encontrada: $($_.FullName)" -ForegroundColor Magenta
    Write-Host "          Verifique manualmente se deve ser removida." -ForegroundColor Magenta
}

# =============================================================================
# PASSO 4 — RESTORE dos arquivos customizados
# =============================================================================
Write-Step 4 5 "Restaurando customizacoes do Lastro sobre o codigo do FlutterFlow..."

$restored = 0
foreach ($relPath in $CUSTOM_FILES) {
    $source = Join-Path $BACKUP_DIR   $relPath
    $dest   = Join-Path $PROJECT_ROOT $relPath
    if (Test-Path $source) {
        $destDir = Split-Path $dest -Parent
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        Copy-Item $source $dest -Force
        Write-OK "Restaurado: $relPath"
        $restored++
    } else {
        Write-SKIP "Sem backup para: $relPath"
    }
}
Write-OK "$restored arquivo(s) customizados restaurados com sucesso!"

# Remove backup temporario (ja nao e necessario)
Remove-Item -Recurse -Force $BACKUP_DIR
Write-OK "Backup temporario removido."

# =============================================================================
# PASSO 5 — PATCHES de infraestrutura + saude do projeto
# =============================================================================
Write-Step 5 5 "Aplicando patches de infraestrutura e verificando saude do projeto..."

# 5a. Patch Android (Gradle, AGP, Kotlin)
Write-Host "    > Patch Android (Gradle/AGP/Kotlin)..." -ForegroundColor DarkYellow
& "$SCRIPTS_DIR\patch_android.ps1"

# 5b. flutter pub get
Write-Host ""
Write-Host "    > flutter pub get..." -ForegroundColor DarkYellow
Set-Location $PROJECT_ROOT
$pubOut = flutter pub get 2>&1
$pubOut | Select-Object -Last 4 | ForEach-Object { Write-Host "      $_" }
Write-OK "Dependencias atualizadas!"

# 5c. flutter analyze (verificacao de saude)
Write-Host ""
Write-Host "    > flutter analyze (verificacao de saude)..." -ForegroundColor DarkYellow
$analyzeOut = flutter analyze 2>&1
$numErrors   = ($analyzeOut | Select-String -Pattern "^\s+error").Count
$numWarnings = ($analyzeOut | Select-String -Pattern "^\s+warning").Count

if ($numErrors -eq 0) {
    Write-OK "Analise: 0 erros | $numWarnings warnings — PROJETO SAUDAVEL!"
} else {
    Write-ERR "Analise: $numErrors ERROS encontrados! Veja abaixo:"
    $analyzeOut | Select-String -Pattern "^\s+error" | Select-Object -First 15 |
        ForEach-Object { Write-Host "      $_" -ForegroundColor Red }
    $errosFinais = $numErrors
}

# =============================================================================
# RESULTADO FINAL
# =============================================================================
Write-Host ""
if ($errosFinais -eq 0) {
    Write-Banner "ATUALIZACAO CONCLUIDA COM SUCESSO!" "Green"
    Write-Host "  Projeto pronto para desenvolvimento." -ForegroundColor Green
} else {
    Write-Banner "ATUALIZACAO CONCLUIDA COM $errosFinais ERROS!" "Yellow"
    Write-Host "  Verifique os erros acima antes de continuar." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Arquivos customizados preservados:" -ForegroundColor Cyan
foreach ($f in $CUSTOM_FILES) {
    $fullPath = Join-Path $PROJECT_ROOT $f
    $status = if (Test-Path $fullPath) { "[OK]" } else { "[AUSENTE!]" }
    $color  = if (Test-Path $fullPath) { "Green" } else { "Red" }
    Write-Host "    $status $f" -ForegroundColor $color
}
Write-Host ""
