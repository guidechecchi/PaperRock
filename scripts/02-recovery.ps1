. "$PSScriptRoot\00-common.ps1"; . "$PSScriptRoot\00-validator.ps1"
PR-Header "rec.title"
Write-Host "  $(t 'rec.pre')`n" -ForegroundColor Cyan
if (-not ((Validate-Deps) -and (Validate-Paths))) { PR-Log "$(t 'common.error')" "ERROR"; PR-Pause; exit 1 }
$rb = [RollbackMgr]::new(); $s = PR-Settings
Write-Host "`n  $(t 'rec.start')`n" -ForegroundColor Cyan
Write-Host "  [1/4] $(t 'rec.fix_adapters')" -NoNewline
try {
  $bad = @(PR-Agents | Where-Object { $_.adapter -ne $s.agents.defaultAdapter })
  if ($bad.Count -eq 0) { Write-Host " [ok]" -ForegroundColor Green }
  else { foreach ($a in $bad) { $rb.Add("AgentPatch", @{ Id = $a.id; Body = @{ adapter = $a.adapter; adapterConfig = $a.adapterConfig } }); $body = @{ adapter = $s.agents.defaultAdapter; adapterConfig = @{ model = $s.ollama.defaultModel; numCtx = $s.agents.defaultContext; workspaceDir = $s.paperclip.workspaceDir; enableFilesystem = $true; enableCreateIssue = $true } } | ConvertTo-Json -Depth 6; Invoke-RestMethod -Method Patch -Uri "$($s.paperclip.url)/api/agents/$($a.id)" -ContentType "application/json" -Body $body -TimeoutSec 10 | Out-Null }; Write-Host " [ok:$($bad.Count)]" -ForegroundColor Green }
} catch { Write-Host " [fail]" -ForegroundColor Red; $rb.Run(); PR-Pause; exit 1 }
Write-Host "  [2/4] $(t 'rec.val_personas'): $(@(Get-ChildItem $s.paperclip.personasDir -Filter 'persona-*.md' -ErrorAction SilentlyContinue).Count)" -ForegroundColor Gray
Write-Host "  [3/4] $(t 'rec.create_files')" -NoNewline
$n = 0
foreach ($a in @(PR-Agents)) { $dir = "$($s.paperclip.workspaceDir)\$($a.name)"; if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null; $rb.Add("DirCreate", @{ Path = $dir }) }; foreach ($f in $s.agents.essentialFiles) { $fp = "$dir\$f"; if (-not (Test-Path $fp)) { Set-Content $fp "# $f`n" -Encoding utf8; $rb.Add("FileCreate", @{ Path = $fp }); $n++ } } }
Write-Host " [ok:$n]" -ForegroundColor Green
Write-Host "  [4/4] $(t 'rec.test_api'): $(if (PR-PaperclipOnline) {'PC:OK'} else {'PC:DOWN'}) / $(if (PR-OllamaOnline) {'OL:OK'} else {'OL:DOWN'})" -ForegroundColor Gray
PR-Log "$(t 'rec.done')" "SUCCESS"; PR-Pause
