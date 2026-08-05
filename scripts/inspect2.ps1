$desktop = [Environment]::GetFolderPath('Desktop')
$folder = Join-Path $desktop "Lastro App - Ferramentas"
$sh = New-Object -ComObject WScript.Shell
Get-ChildItem -Path $folder -Filter "*.lnk" | ForEach-Object {
    $sc = $sh.CreateShortcut($_.FullName)
    Write-Host "File: $($_.Name)"
    Write-Host "Target: $($sc.TargetPath)"
    Write-Host "Args: $($sc.Arguments)"
    Write-Host "--------------------"
}
