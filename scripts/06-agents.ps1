. "$PSScriptRoot\00-common.ps1"
PR-Header "age.title"
$s = PR-Settings; $ag = @(PR-Agents)
Write-Host "  $(t 'age.list') ($($ag.Count)):`n" -ForegroundColor Cyan
$ag | ForEach-Object { Write-Host ("  {0,-14} {1,-14} {2}" -f $_.name, $_.adapter, $_.adapterConfig.model) -ForegroundColor Gray }
Write-Host "`n  [1] $(t 'age.fix_adapters')`n  [2] $(t 'age.set_model')`n  [3] $(t 'age.create')`n  [4] $(t 'age.delete')`n" -ForegroundColor Cyan
$c = Read-Host "  >"
switch ($c) {
  "1" { $n = 0; foreach ($a in @($ag | Where-Object { $_.adapter -ne $s.agents.defaultAdapter })) { Invoke-RestMethod -Method Patch -Uri "$($s.paperclip.url)/api/agents/$($a.id)" -ContentType "application/json" -Body (@{ adapter = $s.agents.defaultAdapter } | ConvertTo-Json) -TimeoutSec 10 | Out-Null; $n++ }; PR-Log "$n $(t 'age.fixed')" "SUCCESS" }
  "2" { $nm = Read-Host "  $(t 'age.name_q')"; $md = Read-Host "  $(t 'age.model_q')"; $m = $ag | Where-Object { $_.name -eq $nm }; if ($m) { Invoke-RestMethod -Method Patch -Uri "$($s.paperclip.url)/api/agents/$($m.id)" -ContentType "application/json" -Body (@{ adapterConfig = @{ model = $md } } | ConvertTo-Json -Depth 4) -TimeoutSec 10 | Out-Null; PR-Log "$nm -> $md" "SUCCESS" } else { PR-Log "$nm $(t 'common.notfound')" "ERROR" } }
  "3" { $nm = Read-Host "  $(t 'age.name_q')"; $cid = PR-CompanyID; $body = @{ name = $nm; description = "Agente $nm."; adapter = $s.agents.defaultAdapter; adapterConfig = @{ model = $s.ollama.defaultModel; numCtx = $s.agents.defaultContext; workspaceDir = $s.paperclip.workspaceDir; enableFilesystem = $true; enableCreateIssue = $true } } | ConvertTo-Json -Depth 6; Invoke-RestMethod -Method Post -Uri "$($s.paperclip.url)/api/companies/$cid/agents" -ContentType "application/json" -Body $body -TimeoutSec 20 | Out-Null; PR-Log "$nm $(t 'age.created')" "SUCCESS" }
  "4" { $nm = Read-Host "  $(t 'age.name_q')"; $m = $ag | Where-Object { $_.name -eq $nm }; if ($m -and (PR-Confirm "$nm?")) { Invoke-RestMethod -Method Delete -Uri "$($s.paperclip.url)/api/agents/$($m.id)" -TimeoutSec 10 | Out-Null; PR-Log "$nm $(t 'age.deleted')" "SUCCESS" } }
}
PR-Pause
