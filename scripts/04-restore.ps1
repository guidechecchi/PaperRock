. "$PSScriptRoot\00-common.ps1"
PR-Header "res.title"
$s = PR-Settings
$zips = @(Get-ChildItem "$PSScriptRoot\..\backups" -Filter "backup_*.zip" | Sort-Object Name -Descending)
if ($zips.Count -eq 0) { PR-Log "$(t 'res.none')" "ERROR"; PR-Pause; exit 1 }
Write-Host "  $(t 'res.list'):`n" -ForegroundColor Cyan
for ($i = 0; $i -lt $zips.Count; $i++) { Write-Host "  [$($i+1)] $($zips[$i].Name)" -ForegroundColor Gray }
$n = [int](Read-Host "`n  $(t 'res.choose')") - 1
if ($n -lt 0 -or $n -ge $zips.Count) { PR-Log "$(t 'common.cancelled')" "WARNING"; PR-Pause; exit 0 }
if (-not (PR-Confirm "$(t 'res.confirm_q')")) { PR-Log "$(t 'common.cancelled')" "WARNING"; PR-Pause; exit 0 }
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) "pr_restore"; if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
Expand-Archive -Path $zips[$n].FullName -DestinationPath $tmp -Force
$man = Get-Content "$tmp\manifest.json" -Raw | ConvertFrom-Json
$bad = 0; $man.PSObject.Properties | ForEach-Object { $f = "$tmp\$($_.Name)"; if ((Test-Path $f) -and ((Get-FileHash $f -Algorithm SHA256).Hash -ne $_.Value)) { $bad++ } }
if ($bad -gt 0) { PR-Log "manifest mismatch: $bad" "ERROR"; PR-Pause; exit 1 }
Write-Host "`n  $(t 'res.restoring')`n" -ForegroundColor Cyan
Remove-Item $s.paperclip.personasDir -Recurse -Force -ErrorAction SilentlyContinue; Copy-Item "$tmp\personas" $s.paperclip.personasDir -Recurse -Force
Remove-Item $s.paperclip.workspaceDir -Recurse -Force -ErrorAction SilentlyContinue; Copy-Item "$tmp\workspaces" $s.paperclip.workspaceDir -Recurse -Force
if (Test-Path "$tmp\dot-paperclip") { Remove-Item "$($s.paperclip.rootDir)\.paperclip" -Recurse -Force -ErrorAction SilentlyContinue; Copy-Item "$tmp\dot-paperclip" "$($s.paperclip.rootDir)\.paperclip" -Recurse -Force }
if (Test-Path "$tmp\agents-config.json") { $cfg = Get-Content "$tmp\agents-config.json" -Raw | ConvertFrom-Json; $cur = @(PR-Agents); foreach ($c in $cfg) { $m = $cur | Where-Object { $_.name -eq $c.name }; if ($m) { Invoke-RestMethod -Method Patch -Uri "$($s.paperclip.url)/api/agents/$($m.id)" -ContentType "application/json" -Body (@{ adapter = $c.adapter; adapterConfig = $c.adapterConfig } | ConvertTo-Json -Depth 8) -TimeoutSec 10 | Out-Null } } }
Remove-Item $tmp -Recurse -Force
PR-Log "$(t 'res.done')" "SUCCESS"; PR-Pause
