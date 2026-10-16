. "$PSScriptRoot\00-common.ps1"
function Validate-Deps {
  $ok = $true
  foreach ($d in @(@("node","node --version"),@("npm","npm --version"),@("ollama","ollama --version"))) {
    try { $v = Invoke-Expression $d[1] 2>$null; if ($v) { Write-Host "  [ok] $($d[0])" -ForegroundColor Green } else { throw } }
    catch { PR-Log "$($d[0]) $(t 'common.notfound')" "ERROR"; $ok = $false }
  }
  return $ok
}
function Validate-Paths { $s = PR-Settings; $ok = $true; foreach ($p in @($s.paperclip.rootDir, $s.paperclip.personasDir, $s.paperclip.workspaceDir)) { if (Test-Path $p) { Write-Host "  [ok] $p" -ForegroundColor Green } else { PR-Log "$p $(t 'common.notfound')" "ERROR"; $ok = $false } }; return $ok }
function Validate-Disk([int]$MinGB = 5) { $free = PR-DiskFreeGB (PR-Settings).paperclip.rootDir; if ($free -ge $MinGB) { Write-Host "  [ok] $free GB" -ForegroundColor Green; return $true }; PR-Log "$free GB < $MinGB GB" "ERROR"; return $false }
