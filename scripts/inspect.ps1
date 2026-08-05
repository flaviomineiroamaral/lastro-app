$sh = New-Object -ComObject WScript.Shell
Get-ChildItem 'C:\Users\sigma\OneDrive\Área de Trabalho\Lastro App - Ferramentas\*.lnk' | ForEach-Object {
    $sc = $sh.CreateShortcut($_.FullName)
    Write-Host "Name: $($_.Name)"
    Write-Host "Target: $($sc.TargetPath)"
    Write-Host "Args: $($sc.Arguments)"
    Write-Host "---"
}
