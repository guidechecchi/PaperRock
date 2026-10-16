$script:i18n = $null; $script:lang = "en-US"
$script:IsWin = [System.Environment]::OSVersion.Platform -eq "Win32NT"
function PR-Editor([string]$Path) { if ($script:IsWin) { notepad $Path } else { $e = if ($env:EDITOR) { $env:EDITOR } else { "nano" }; & $e $Path } }
function PR-DiskFreeGB([string]$Path) { try { $root = [System.IO.Path]::GetPathRoot((Resolve-Path $Path).Path); $d = New-Object System.IO.DriveInfo($root); return [math]::Round($d.AvailableFreeSpace/1GB,2) } catch { return -1 } }
function Initialize-i18n {
  $lf = "$PSScriptRoot\..\config\language.json"
  if (-not (Test-Path $lf)) {
    Clear-Host
    Write-Host "`n  Select language / Selecione o idioma / 选择语言`n" -ForegroundColor Cyan
    Write-Host "  [1] Portugues (Brasil)" -ForegroundColor Gray
    Write-Host "  [2] English (US)" -ForegroundColor Gray
    Write-Host "  [3] Chinese (Simplified)`n" -ForegroundColor Gray
    $c = Read-Host "  >"
    $script:lang = switch ($c) { "1" {"pt-BR"} "3" {"zh-CN"} default {"en-US"} }
    @{ language = $script:lang } | ConvertTo-Json | Set-Content $lf -Encoding utf8
  } else { $script:lang = (Get-Content $lf -Raw -Encoding utf8 | ConvertFrom-Json).language }
  $sf = "$PSScriptRoot\..\i18n\$($script:lang).json"
  if (-not (Test-Path $sf)) { $sf = "$PSScriptRoot\..\i18n\en-US.json"; $script:lang = "en-US" }
  $script:i18n = Get-Content $sf -Raw -Encoding utf8 | ConvertFrom-Json
}
function t([string]$Key) { $v = $script:i18n; foreach ($p in ($Key -split '\.')) { if ($v.PSObject.Properties[$p]) { $v = $v.$p } else { return "[$Key]" } }; return $v }
function PR-Header([string]$TitleKey) {
  if (-not $script:i18n) { Initialize-i18n }
  Clear-Host
  @('  ██████╗  █████╗ ██████╗ ███████╗██████╗  ██████╗  ██████╗  ██████╗██╗  ██╗',
    '  ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝██║ ██╔╝',
    '  ██████╔╝███████║██████╔╝█████╗  ██████╔╝██║   ██║██║   ██║██║     █████╔╝ ',
    '  ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗██║   ██║██║   ██║██║     ██╔═██╗ ',
    '  ██║     ██║  ██║██║     ███████╗██║  ██║╚██████╔╝╚██████╔╝╚██████╗██║  ██╗',
    '  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝') | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
  Write-Host "`n  PaperRock - $(t $TitleKey)`n" -ForegroundColor Yellow
}
function PR-Settings { $f = "$PSScriptRoot\..\config\settings.json"; if (-not (Test-Path $f)) { Copy-Item "$PSScriptRoot\..\config\settings.example.json" $f }; return Get-Content $f -Raw -Encoding utf8 | ConvertFrom-Json }
function PR-Log([string]$Msg,[string]$Level="INFO") { $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] $Msg"; Add-Content "$PSScriptRoot\..\logs\paperrrock.log" $line -Encoding utf8; $c = switch ($Level) { "SUCCESS"{"Green"} "WARNING"{"Yellow"} "ERROR"{"Red"} default{"Gray"} }; Write-Host "  [$Level] $Msg" -ForegroundColor $c }
function PR-Pause { Write-Host "`n  $(t 'common.press')" -ForegroundColor DarkGray; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
function PR-Confirm([string]$Msg) { $r = Read-Host "  $Msg ($(t 'common.yes')/$(t 'common.no'))"; return ($r -ieq (t 'common.yes') -or $r -ieq 'y' -or $r -ieq 's') }
function PR-PaperclipOnline { try { Invoke-RestMethod -Uri "$((PR-Settings).paperclip.url)/api/companies" -TimeoutSec 5 | Out-Null; return $true } catch { return $false } }
function PR-OllamaOnline { try { Invoke-WebRequest -Uri "$((PR-Settings).ollama.url)/api/tags" -TimeoutSec 5 | Out-Null; return $true } catch { return $false } }
function PR-CompanyID { $c = Invoke-RestMethod -Uri "$((PR-Settings).paperclip.url)/api/companies"; if ($c -is [array]) { return $c[0].id }; return $c.id }
function PR-Agents { $cid = PR-CompanyID; $a = Invoke-RestMethod -Uri "$((PR-Settings).paperclip.url)/api/companies/$cid/agents"; if ($a -is [array]) { return $a }; return $a.items }
class RollbackMgr {
  [array]$Ops = @()
  [void] Add([string]$Type,[hashtable]$P) { $this.Ops += @{Type=$Type;P=$P} }
  [void] Run() { Write-Host "`n  ROLLBACK..." -ForegroundColor Yellow; for ($i = $this.Ops.Count - 1; $i -ge 0; $i--) { $o = $this.Ops[$i]; try { switch ($o.Type) { "FileCreate" { Remove-Item $o.P.Path -Force -ErrorAction SilentlyContinue } "DirCreate" { Remove-Item $o.P.Path -Recurse -Force -ErrorAction SilentlyContinue } "AgentPatch" { $s = PR-Settings; Invoke-RestMethod -Method Patch -Uri "$($s.paperclip.url)/api/agents/$($o.P.Id)" -ContentType "application/json" -Body ($o.P.Body | ConvertTo-Json -Depth 6) -TimeoutSec 10 | Out-Null } } ; Write-Host "  [rollback] $($o.Type)" -ForegroundColor Yellow } catch { Write-Host "  [rollback-fail] $_" -ForegroundColor Red } } }
}
Initialize-i18n
