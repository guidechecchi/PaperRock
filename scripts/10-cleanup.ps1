. "$PSScriptRoot\00-common.ps1"
PR-Header "cln.title"
$s = PR-Settings
Write-Host "  $(t 'cln.scan')`n" -ForegroundColor Cyan
$items = @()
Get-ChildItem "$PSScriptRoot\..\logs" -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | ForEach-Object { $items += $_ }
$names = @(PR-Agents | ForEach-Object { $_.name })
Get-ChildItem $s.paperclip.workspaceDir -Directory -ErrorAction SilentlyContinue | Where-Object { $names -notcontains $_.Name -and $_.Name -notmatch '^[0-9a-f-]{36}$' } | ForEach-Object { $items += $_ }
$sz = [math]::Round(($items | Measure-Object Length -Sum).Sum / 1MB, 2)
Write-Host "  $(t 'cln.preview'): $sz MB ($($items.Count))`n" -ForegroundColor Cyan
$items | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Gray }
if ($items.Count -gt 0 -and (PR-Confirm "$(t 'cln.confirm_q')")) { $items | Remove-Item -Recurse -Force; PR-Log "$(t 'cln.freed'): $sz MB" "SUCCESS" } else { PR-Log "$(t 'common.cancelled')" "WARNING" }
PR-Pause
