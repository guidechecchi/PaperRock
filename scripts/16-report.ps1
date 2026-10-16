. "$PSScriptRoot\00-common.ps1"
PR-Header "rep.title"
$s = PR-Settings
Write-Host "  $(t 'rep.gen')`n" -ForegroundColor Cyan
$pc = PR-PaperclipOnline; $ol = PR-OllamaOnline
$agc = @(PR-Agents).Count; $pec = @(Get-ChildItem $s.paperclip.personasDir -Filter "persona-*.md" -ErrorAction SilentlyContinue).Count
$free = PR-DiskFreeGB $s.paperclip.rootDir
$html = "<html><head><meta charset='utf-8'><title>PaperRock Report</title><style>body{font-family:Segoe UI;background:#111;color:#eee;padding:40px}h1{color:#22d3ee}td{padding:6px 18px;border-bottom:1px solid #333}.ok{color:#4ade80}.bad{color:#f87171}</style></head><body><h1>PaperRock Report - $(Get-Date -Format 'yyyy-MM-dd HH:mm')</h1><table><tr><td>Paperclip API</td><td class='$(if($pc){'ok'}else{'bad'})'>$pc</td></tr><tr><td>Ollama API</td><td class='$(if($ol){'ok'}else{'bad'})'>$ol</td></tr><tr><td>Agents</td><td>$agc</td></tr><tr><td>Personas</td><td>$pec</td></tr><tr><td>Disk free</td><td>$free GB</td></tr></table></body></html>"
$out = "$PSScriptRoot\..\reports\report_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
Set-Content $out $html -Encoding utf8
PR-Log "$(t 'rep.done'): $out" "SUCCESS"
if (PR-Confirm "$(t 'rep.open')") { Start-Process $out }
PR-Pause
