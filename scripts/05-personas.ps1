. "$PSScriptRoot\00-common.ps1"
PR-Header "per.title"
$s = PR-Settings
$pe = @(Get-ChildItem $s.paperclip.personasDir -Filter "persona-*.md" -ErrorAction SilentlyContinue)
Write-Host "  $(t 'per.list'): $($pe.Count)`n" -ForegroundColor Cyan
$pe | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }
$missing = @(PR-Agents | Where-Object { -not (Test-Path "$($s.paperclip.personasDir)\persona-$($_.name.ToLower() -replace '[^a-z0-9]+','-').md") })
if ($missing.Count -gt 0) { Write-Host "`n  $(t 'per.missing'): $($missing.Count)" -ForegroundColor Yellow; if (PR-Confirm "$(t 'per.create')") { foreach ($a in $missing) { $slug = $a.name.ToLower() -replace '[^a-z0-9]+','-'; $tpl = @("# PERSONA: $($a.name)", "", $a.description, "", "## REGRAS", "- Responda em PT-BR.", "- Feche tarefas com done.") -join "`r`n"; Set-Content "$($s.paperclip.personasDir)\persona-$slug.md" $tpl -Encoding utf8 }; PR-Log "$($missing.Count) $(t 'per.created')" "SUCCESS" } }
if (PR-Confirm "$(t 'per.edit')") { $f = Read-Host "  arquivo"; $p = "$($s.paperclip.personasDir)\$f"; if (Test-Path $p) { PR-Editor $p } else { PR-Log "$f $(t 'common.notfound')" "ERROR" } }
PR-Pause
