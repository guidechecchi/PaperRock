. "$PSScriptRoot\00-common.ps1"; . "$PSScriptRoot\00-validator.ps1"
PR-Header "hc.title"
Write-Host "  $(t 'hc.run')`n" -ForegroundColor Cyan
$score = 0; $tot = 5
if (PR-PaperclipOnline) { $score++; Write-Host "  [ok] Paperclip API" -ForegroundColor Green } else { Write-Host "  [xx] Paperclip API" -ForegroundColor Red }
if (PR-OllamaOnline) { $score++; Write-Host "  [ok] Ollama API" -ForegroundColor Green } else { Write-Host "  [xx] Ollama API" -ForegroundColor Red }
if (Validate-Disk 5) { $score++ }
if ((@(PR-Agents).Count) -gt 0) { $score++; Write-Host "  [ok] Agents" -ForegroundColor Green } else { Write-Host "  [xx] Agents" -ForegroundColor Red }
if ((@(Get-ChildItem (PR-Settings).paperclip.personasDir -Filter "persona-*.md" -ErrorAction SilentlyContinue).Count) -gt 0) { $score++; Write-Host "  [ok] Personas" -ForegroundColor Green } else { Write-Host "  [xx] Personas" -ForegroundColor Red }
$lv = if ($score -eq $tot) { "ok" } elseif ($score -ge 3) { "warn" } else { "bad" }
Write-Host "`n  >>> $(t "hc.$lv") ($score/$tot)`n" -ForegroundColor $(if ($lv -eq "ok") {"Green"} elseif ($lv -eq "warn") {"Yellow"} else {"Red"})
PR-Log "health: $score/$tot" "SUCCESS"; PR-Pause
