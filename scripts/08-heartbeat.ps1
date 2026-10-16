. "$PSScriptRoot\00-common.ps1"
PR-Header "hb.title"
Write-Host "  $(t 'hb.desc')`n" -ForegroundColor Cyan
$s = PR-Settings; $ag = @(PR-Agents)
for ($i = 0; $i -lt $ag.Count; $i++) { Write-Host "  [$($i+1)] $($ag[$i].name)" -ForegroundColor Gray }
$n = [int](Read-Host "`n  $(t 'hb.select')") - 1
$a = $ag[$n]; Write-Host "  $(t 'hb.sel_ok'): $($a.name)" -ForegroundColor Green
$fq = Read-Host "  $(t 'hb.freq_q')"; $tk = Read-Host "  $(t 'hb.task_q')"
$dir = "$($s.paperclip.workspaceDir)\$($a.name)"; New-Item -ItemType Directory -Force -Path $dir | Out-Null
$tpl = @("# HEARTBEAT.md - $($a.name)", "", "## Frequencia", $fq, "", "## Tarefas Automaticas", "### 1. $tk", "- Ferramentas: paperclip_list_issues, paperclip_get_issue", "- Output: relatorio de status", "", "## Condicoes de Parada", "- Erro critico: notificar superior", "- Orcamento excedido: pausar e pedir aprovacao") -join "`r`n"
Set-Content "$dir\HEARTBEAT.md" $tpl -Encoding utf8
PR-Log "$(t 'hb.created'): $dir\HEARTBEAT.md" "SUCCESS"
if (PR-Confirm "$(t 'hb.sched_q')") {
  $ps = "$PSScriptRoot\hb_$($a.name -replace '[^a-z0-9]','').ps1"
  $body = "`$s = Get-Content '$PSScriptRoot\..\config\settings.json' -Raw -Encoding utf8 | ConvertFrom-Json; `$cid = (Invoke-RestMethod (`$s.paperclip.url + '/api/companies')); if (`$cid -is [array]) { `$cid = `$cid[0].id }; Invoke-RestMethod -Method Post -Uri (`$s.paperclip.url + '/api/companies/' + `$cid + '/issues') -ContentType 'application/json' -Body (@{ title = 'HEARTBEAT: $($a.name)'; assigneeAgentId = '$($a.id)'; description = '$tk' } | ConvertTo-Json)"
  Set-Content $ps $body -Encoding utf8
  if ($script:IsWin) { $act = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ps`""; $trg = New-ScheduledTaskTrigger -Daily -At 8:00AM; Register-ScheduledTask -TaskName "PaperRock_HB_$($a.name)" -Action $act -Trigger $trg -Force | Out-Null }
  else { Write-Host "  cron: 0 8 * * * pwsh -NoProfile -File $ps" -ForegroundColor Yellow }
  PR-Log "$(t 'hb.sched_done')" "SUCCESS"
}
PR-Pause
