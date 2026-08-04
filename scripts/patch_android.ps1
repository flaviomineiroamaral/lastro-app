# Script para re-aplicar correcoes de build Android apos exportar do FlutterFlow
$gradleProps = "C:\SIGMA\lastro-app\lastro_sigma_sistemas\android\gradle\wrapper\gradle-wrapper.properties"
$settingsGradle = "C:\SIGMA\lastro-app\lastro_sigma_sistemas\android\settings.gradle"

Write-Host "Aplicando correcoes de infraestrutura Android..." -ForegroundColor Cyan

if (Test-Path $gradleProps) {
    (Get-Content $gradleProps) -replace 'gradle-.*-all.zip', 'gradle-8.14.0-all.zip' | Set-Content $gradleProps
    Write-Host "[OK] Gradle Wrapper atualizado para 8.14.0" -ForegroundColor Green
}

if (Test-Path $settingsGradle) {
    $content = Get-Content $settingsGradle -Raw
    $content = $content -replace '"com.android.application" version ".*"', '"com.android.application" version "8.11.1"'
    $content = $content -replace '"org.jetbrains.kotlin.android" version ".*"', '"org.jetbrains.kotlin.android" version "2.2.20"'
    Set-Content $settingsGradle $content
    Write-Host "[OK] AGP (8.11.1) e Kotlin (2.2.20) atualizados no settings.gradle" -ForegroundColor Green
}

Write-Host "Re-aplicacao concluida com sucesso!" -ForegroundColor Cyan
