. "$PSScriptRoot\00-common.ps1"
PR-Header "set.title"
$f = "$PSScriptRoot\..\config\settings.json"
Write-Host "  $(t 'set.show'):`n" -ForegroundColor Cyan
Get-Content $f -Raw -Encoding utf8 | Write-Host -ForegroundColor Gray
Write-Host "`n  [1] $(t 'set.edit')`n  [2] $(t 'set.reset')`n  [3] editor`n" -ForegroundColor Cyan
$c = Read-Host "  >"
$json = Get-Content $f -Raw -Encoding utf8 | ConvertFrom-Json
switch ($c) {
  "1" { $k = Read-Host "  $(t 'set.key_q')"; $v = Read-Host "  $(t 'set.val_q')"; $parts = $k -split '\.'; $node = $json; for ($i = 0; $i -lt $parts.Count - 1; $i++) { $node = $node.$($parts[$i]) }; $node.$($parts[-1]) = $v; $json | ConvertTo-Json -Depth 10 | Set-Content $f -Encoding utf8; PR-Log "$(t 'set.saved')" "SUCCESS" }
  "2" { Copy-Item "$PSScriptRoot\..\config\settings.example.json" $f -Force; PR-Log "$(t 'set.saved')" "SUCCESS" }
  "3" { PR-Editor $f }
}
PR-Pause
