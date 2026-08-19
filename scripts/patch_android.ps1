# Script para re-aplicar correções de infraestrutura Android e Intent Filters após exportar do FlutterFlow
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$projectRoot = Split-Path -Parent $baseDir

$gradleProps = Join-Path $projectRoot "android/gradle/wrapper/gradle-wrapper.properties"
$settingsGradle = Join-Path $projectRoot "android/settings.gradle"
$manifestFile = Join-Path $projectRoot "android/app/src/main/AndroidManifest.xml"

Write-Host "Aplicando correções de infraestrutura Android..." -ForegroundColor Cyan

# 1. Gradle Wrapper
if (Test-Path $gradleProps) {
    (Get-Content $gradleProps) -replace '^distributionUrl=.*', 'distributionUrl=https\://services.gradle.org/distributions/gradle-9.1.0-all.zip' | Set-Content $gradleProps
    Write-Host "[OK] Gradle 9.1.0 configurado" -ForegroundColor Green
}

# 2. AGP e Kotlin
if (Test-Path $settingsGradle) {
    $content = Get-Content $settingsGradle -Raw
    $content = $content -replace '"com.android.application" version ".*"', '"com.android.application" version "9.0.1"'
    $content = $content -replace '"org.jetbrains.kotlin.android" version ".*"', '"org.jetbrains.kotlin.android" version "2.3.20"'
    Set-Content $settingsGradle $content
    Write-Host "[OK] AGP 9.0.1 e Kotlin 2.3.20 configurados" -ForegroundColor Green
}

# 3. Share Intent Filter em AndroidManifest.xml (Receber PDFs/OFX de apps bancários)
if (Test-Path $manifestFile) {
    $manifestContent = Get-Content $manifestFile -Raw
    if ($manifestContent -notmatch 'android.intent.action.SEND') {
        $shareIntentBlock = @"

            <!-- Share Intent: Receber arquivos compartilhados de outros apps (ex: app do banco) -->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="application/x-ofx" />
                <data android:mimeType="application/ofx" />
                <data android:mimeType="application/pdf" />
                <data android:mimeType="text/csv" />
                <data android:mimeType="text/comma-separated-values" />
                <data android:mimeType="application/octet-stream" />
                <data android:mimeType="*/*" />
            </intent-filter>
"@
        $manifestContent = $manifestContent -replace '(\s*</activity>)', "$shareIntentBlock`$1"
        Set-Content $manifestFile $manifestContent
        Write-Host "[OK] Share Intent Filter (Compartilhamento de Banco) injetado com sucesso no AndroidManifest" -ForegroundColor Green
    } else {
        Write-Host "[OK] Share Intent Filter ja esta presente no AndroidManifest" -ForegroundColor Green
    }
}

Write-Host "Re-aplicacao concluida com sucesso!" -ForegroundColor Cyan
