. "$PSScriptRoot\00-common.ps1"
PR-Header "oll.title"
Write-Host "  $(t 'oll.list'):`n" -ForegroundColor Cyan
ollama list | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
$vram = 0; if ($script:IsWin) { $vram = [math]::Round(((Get-CimInstance Win32_VideoController | Measure-Object AdapterRAM -Maximum).Maximum / 1GB), 1) }
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 0)
Write-Host "`n  $(t 'oll.vram'): $vram GB | RAM: $ram GB" -ForegroundColor Cyan
$rec = if ($vram -ge 12) { "qwen2.5:32b" } elseif ($vram -ge 8) { "qwen2.5:14b" } elseif ($vram -ge 4) { "qwen3:8b" } else { "qwen2.5:3b" }
Write-Host "  $(t 'oll.rec'): $rec`n" -ForegroundColor Yellow
Write-Host "  [1] $(t 'oll.pull')`n  [2] $(t 'oll.remove')`n" -ForegroundColor Cyan
$c = Read-Host "  >"
if ($c -eq "1") { $m = Read-Host "  $(t 'oll.name_q')"; ollama pull $m; PR-Log "$m $(t 'oll.pulled')" "SUCCESS" }
if ($c -eq "2") { $m = Read-Host "  $(t 'oll.name_q')"; if (PR-Confirm "$m?") { ollama rm $m; PR-Log "$m $(t 'oll.removed')" "SUCCESS" } }
PR-Pause
