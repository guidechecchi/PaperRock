. "$PSScriptRoot\00-common.ps1"
PR-Header "diag.title"
Write-Host "  $(t 'diag.running')`n" -ForegroundColor Cyan
$s = PR-Settings
Write-Host "  [1/8] $(t 'diag.api_pc'): " -NoNewline; if (PR-PaperclipOnline) { Write-Host "$(t 'common.online')" -ForegroundColor Green } else { Write-Host "$(t 'common.offline')" -ForegroundColor Red }
Write-Host "  [2/8] $(t 'diag.api_ol'): " -NoNewline; if (PR-OllamaOnline) { Write-Host "$(t 'common.online')" -ForegroundColor Green } else { Write-Host "$(t 'common.offline')" -ForegroundColor Red }
$mc = (ollama list 2>$null | Measure-Object).Count; Write-Host "  [3/8] $(t 'diag.models'): $([math]::Max(0,$mc-1))" -ForegroundColor Gray
$ag = @(); try { $ag = @(PR-Agents) } catch {}
Write-Host "  [4/8] $(t 'diag.agents'): $($ag.Count)" -ForegroundColor Gray
$pe = @(Get-ChildItem $s.paperclip.personasDir -Filter "persona-*.md" -ErrorAction SilentlyContinue)
Write-Host "  [5/8] $(t 'diag.personas'): $($pe.Count)" -ForegroundColor Gray
$bad = @($ag | Where-Object { $_.adapter -ne $s.agents.defaultAdapter })
if ($bad.Count -eq 0) { Write-Host "  [6/8] $(t 'diag.adapters'): $(t 'diag.ok_all_adapters')" -ForegroundColor Green } else { Write-Host "  [6/8] $(t 'diag.adapters'): $($bad.Count) $(t 'diag.wrong_adapters')" -ForegroundColor Yellow }
$miss = 0; foreach ($a in $ag) { foreach ($f in $s.agents.essentialFiles) { if (-not (Test-Path "$($s.paperclip.workspaceDir)\$($a.name)\$f")) { $miss++ } } }
if ($miss -eq 0) { Write-Host "  [7/8] $(t 'diag.files'): $(t 'diag.all_files')" -ForegroundColor Green } else { Write-Host "  [7/8] $(t 'diag.files'): $miss $(t 'diag.missing')" -ForegroundColor Yellow }
Write-Host "  [8/8] $(t 'diag.disk'): $(PR-DiskFreeGB $s.paperclip.rootDir) GB" -ForegroundColor Gray
PR-Log "$(t 'diag.concluded')" "SUCCESS"; PR-Pause
