. "$PSScriptRoot\00-common.ps1"
PR-Header "emg.title"
$s = PR-Settings
Write-Host "  [1] $(t 'emg.opt1')`n  [2] $(t 'emg.opt2')`n  [3] $(t 'emg.opt3')`n  [4] $(t 'emg.opt4')`n  [5] $(t 'emg.opt5')`n" -ForegroundColor Cyan
$c = Read-Host "  >"
switch ($c) {
  "1" { if (PR-Confirm "$(t 'emg.opt1')") { Get-Process node,postgres -ErrorAction SilentlyContinue | Stop-Process -Force; PR-Log "$(t 'emg.done')" "SUCCESS" } }
  "2" { $lk = "$($s.paperclip.rootDir)\.paperclip\instances\default\db\postmaster.pid"; if (Test-Path $lk) { Remove-Item $lk -Force; PR-Log "postmaster.pid removed" "SUCCESS" } else { PR-Log "lock $(t 'common.notfound')" "WARNING" } }
  "3" { foreach ($a in @(PR-Agents)) { Invoke-RestMethod -Method Patch -Uri "$($s.paperclip.url)/api/agents/$($a.id)" -ContentType "application/json" -Body (@{ adapter = $s.agents.defaultAdapter } | ConvertTo-Json) -TimeoutSec 10 | Out-Null }; PR-Log "$(t 'emg.done')" "SUCCESS" }
  "4" { foreach ($a in @(PR-Agents)) { $d = "$($s.paperclip.workspaceDir)\$($a.name)"; New-Item -ItemType Directory -Force -Path $d | Out-Null; foreach ($f in $s.agents.essentialFiles) { $fp = "$d\$f"; if (-not (Test-Path $fp)) { Set-Content $fp "# $f`n" -Encoding utf8 } } }; PR-Log "$(t 'emg.done')" "SUCCESS" }
  "5" { $r = Read-Host "  $(t 'emg.confirm_reset')"; if ($r -ceq "RESET") { Remove-Item "$($s.paperclip.rootDir)\.paperclip" -Recurse -Force; PR-Log "FULL RESET" "WARNING" } else { PR-Log "$(t 'common.cancelled')" "WARNING" } }
}
PR-Pause
