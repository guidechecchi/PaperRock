. "$PSScriptRoot\00-common.ps1"
PR-Header "dry.title"
$s = PR-Settings
Write-Host "  $(t 'dry.plan'):`n" -ForegroundColor Cyan
$sz = [math]::Round(((Get-ChildItem $s.paperclip.personasDir -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum + (Get-ChildItem $s.paperclip.workspaceDir -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum) / 1MB, 2)
Write-Host "  - $(t 'dry.backup_would'): $sz MB" -ForegroundColor Yellow
Write-Host "  - $(t 'dry.recovery_would'): $(@(PR-Agents | Where-Object { $_.adapter -ne $s.agents.defaultAdapter }).Count) adapters" -ForegroundColor Yellow
$miss = 0; foreach ($a in @(PR-Agents)) { foreach ($f in $s.agents.essentialFiles) { if (-not (Test-Path "$($s.paperclip.workspaceDir)\$($a.name)\$f")) { $miss++ } } }
Write-Host "  - $(t 'rec.create_files'): $miss" -ForegroundColor Yellow
PR-Log "$(t 'dry.end')" "SUCCESS"; PR-Pause
