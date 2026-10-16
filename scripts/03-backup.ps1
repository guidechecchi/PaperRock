. "$PSScriptRoot\00-common.ps1"
PR-Header "bak.title"
$s = PR-Settings; $ts = Get-Date -Format "yyyyMMdd_HHmmss"
$stage = Join-Path ([System.IO.Path]::GetTempPath()) "pr_backup_$ts"; New-Item -ItemType Directory -Force -Path $stage | Out-Null
Write-Host "  $(t 'bak.creating')`n" -ForegroundColor Cyan
Copy-Item $s.paperclip.personasDir "$stage\personas" -Recurse -Force; Write-Host "  [ok] $(t 'bak.personas')" -ForegroundColor Green
Copy-Item $s.paperclip.workspaceDir "$stage\workspaces" -Recurse -Force; Write-Host "  [ok] $(t 'bak.workspaces')" -ForegroundColor Green
if (Test-Path "$($s.paperclip.rootDir)\.paperclip") { Copy-Item "$($s.paperclip.rootDir)\.paperclip" "$stage\dot-paperclip" -Recurse -Force; Write-Host "  [ok] $(t 'bak.config')" -ForegroundColor Green }
try { $cfg = @(PR-Agents | ForEach-Object { @{ name = $_.name; description = $_.description; adapter = $_.adapter; adapterConfig = $_.adapterConfig } }); $cfg | ConvertTo-Json -Depth 8 | Set-Content "$stage\agents-config.json" -Encoding utf8; Write-Host "  [ok] $(t 'bak.agents')" -ForegroundColor Green } catch { PR-Log "agents-config: $_" "WARNING" }
$man = @{}; Get-ChildItem $stage -Recurse -File | ForEach-Object { $man[$_.FullName.Substring($stage.Length + 1)] = (Get-FileHash $_.FullName -Algorithm SHA256).Hash }
$man | ConvertTo-Json | Set-Content "$stage\manifest.json" -Encoding utf8
$zip = "$PSScriptRoot\..\backups\backup_$ts.zip"
Compress-Archive -Path "$stage\*" -DestinationPath $zip -Force
Remove-Item $stage -Recurse -Force
PR-Log "$(t 'bak.done'): $zip ($([math]::Round((Get-Item $zip).Length/1MB,2)) MB)" "SUCCESS"
$all = @(Get-ChildItem "$PSScriptRoot\..\backups" -Filter "backup_*.zip" | Sort-Object Name -Descending)
if ($all.Count -gt $s.backup.maxBackups) { Write-Host "  $(t 'bak.clean')" -ForegroundColor Yellow; $all | Select-Object -Skip $s.backup.maxBackups | Remove-Item -Force }
PR-Pause
