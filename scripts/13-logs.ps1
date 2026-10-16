. "$PSScriptRoot\00-common.ps1"
PR-Header "log.title"
$lf = "$PSScriptRoot\..\logs\paperrrock.log"
if (-not (Test-Path $lf)) { PR-Log "log $(t 'common.notfound')" "ERROR"; PR-Pause; exit 1 }
$n = Read-Host "  $(t 'log.tail') [50]"; if (-not $n) { $n = 50 }
$f = Read-Host "  $(t 'log.filter')"
$lines = Get-Content $lf -Encoding utf8 | Select-Object -Last $n
if ($f) { $lines = $lines | Where-Object { $_ -match "\[$f\]" } }
$lines | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
if (PR-Confirm "clear?") { Set-Content $lf "" -Encoding utf8; PR-Log "$(t 'log.cleared')" "SUCCESS" }
PR-Pause
