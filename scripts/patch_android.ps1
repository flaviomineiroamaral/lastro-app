# Script para re-aplicar correções de infraestrutura Android e Intent Filters após exportar do FlutterFlow
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$projectRoot = Split-Path -Parent $baseDir

$gradleProps = Join-Path $projectRoot "android/gradle/wrapper/gradle-wrapper.properties"
$gradleProperties = Join-Path $projectRoot "android/gradle.properties"
$settingsGradle = Join-Path $projectRoot "android/settings.gradle"
$appBuildGradle = Join-Path $projectRoot "android/app/build.gradle"
$manifestFile = Join-Path $projectRoot "android/app/src/main/AndroidManifest.xml"

Write-Host "Aplicando correções de infraestrutura Android..." -ForegroundColor Cyan

# 1. Gradle Wrapper 9.1.0
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

# 3. Remover flags obsoletas do gradle.properties
if (Test-Path $gradleProperties) {
    $content = Get-Content $gradleProperties -Raw
    $content = $content -replace 'android\.enableR8=true', ''
    Set-Content $gradleProperties $content
    Write-Host "[OK] Flag enableR8 obsoleta removida" -ForegroundColor Green
}

# 4. ProGuard e Sufixo Dev no app/build.gradle
if (Test-Path $appBuildGradle) {
    $content = Get-Content $appBuildGradle -Raw
    $content = $content -replace "proguard-android\.txt", "proguard-android-optimize.txt"
    if ($content -notmatch 'applicationIdSuffix ".dev"') {
        $content = $content -replace 'buildTypes\s*\{', "buildTypes {`n        debug {`n            applicationIdSuffix `".dev`"`n        }"
    }
    Set-Content $appBuildGradle $content
    Write-Host "[OK] ProGuard otimizado e sufixo .dev para ambiente de desenvolvimento configurados" -ForegroundColor Green
}

# 5. Share Intent Filters e launchMode em AndroidManifest.xml (Receber PDFs/OFX de apps bancários)
if (Test-Path $manifestFile) {
    $manifestContent = Get-Content $manifestFile -Raw

    # 5a. Corrige launchMode para singleTask (requisito do receive_sharing_intent)
    if ($manifestContent -match 'android:launchMode="singleTop"') {
        $manifestContent = $manifestContent -replace 'android:launchMode="singleTop"', 'android:launchMode="singleTask"'
        Write-Host "[OK] launchMode corrigido para singleTask" -ForegroundColor Green
    }

    # 5b. Injeta os intent-filters de Share separados por mimeType
    if ($manifestContent -notmatch 'android.intent.action.SEND') {
        $shareIntentBlock = @"

            <!-- Share Intent Filters: Prioridade alta para PDF, CSV e OFX para aparecer direto no Share Sheet principal -->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="application/pdf" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="application/pdf" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="text/csv" />
                <data android:mimeType="text/comma-separated-values" />
                <data android:mimeType="text/plain" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="text/csv" />
                <data android:mimeType="text/comma-separated-values" />
                <data android:mimeType="text/plain" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="application/x-ofx" />
                <data android:mimeType="application/ofx" />
                <data android:mimeType="application/octet-stream" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="application/x-ofx" />
                <data android:mimeType="application/ofx" />
                <data android:mimeType="application/octet-stream" />
            </intent-filter>
            <!-- Fallback para qualquer outro tipo de arquivo -->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="*/*" />
            </intent-filter>
"@
        $manifestContent = $manifestContent -replace '(\s*</activity>)', "$shareIntentBlock`$1"
        Set-Content $manifestFile $manifestContent
        Write-Host "[OK] Share Intent Filters (Compartilhamento de Banco) injetados com sucesso no AndroidManifest" -ForegroundColor Green
    } else {
        Write-Host "[OK] Share Intent Filters ja estao presentes no AndroidManifest" -ForegroundColor Green
    }
}

Write-Host "Re-aplicacao concluida com sucesso!" -ForegroundColor Cyan

