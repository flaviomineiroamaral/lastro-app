# Script alias para finish_day.ps1
param (
    [string]$CommitMessage = "feat: salvamento automatico de expediente"
)
& "C:\SIGMA\lastro-app\scripts\finish_day.ps1" -CommitMessage $CommitMessage
