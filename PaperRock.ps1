. "$PSScriptRoot\scripts\00-common.ps1"
$map = @{1="01-diagnostic";2="02-recovery";3="11-health-check";4="12-emergency";5="03-backup";6="04-restore";7="03-backup";8="10-cleanup";9="05-personas";10="06-agents";11="07-ollama";12="08-heartbeat";13="09-soul";14="10-cleanup";15="13-logs";16="14-settings";17="15-dry-run";18="16-report"}
while ($true) {
  Clear-Host
  @('  ██████╗  █████╗ ██████╗ ███████╗██████╗  ██████╗  ██████╗  ██████╗██╗  ██╗',
    '  ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝██║ ██╔╝',
    '  ██████╔╝███████║██████╔╝█████╗  ██████╔╝██║   ██║██║   ██║██║     █████╔╝ ',
    '  ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗██║   ██║██║   ██║██║     ██╔═██╗ ',
    '  ██║     ██║  ██║██║     ███████╗██║  ██║╚██████╝╚██████╔╝╚██████╗██║  ██╗',
    '  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝') | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
  Write-Host "`n  PaperRock v$(t 'app.version') - $(t 'app.tagline')  [$script:lang]`n" -ForegroundColor Yellow
  Write-Host "  -- $(t 'menu.sec1') --" -ForegroundColor DarkCyan
  Write-Host "   [1] $(t 'menu.item1')   [2] $(t 'menu.item2')" -ForegroundColor Gray
  Write-Host "   [3] $(t 'menu.item3')   [4] $(t 'menu.item4')" -ForegroundColor Gray
  Write-Host "  -- $(t 'menu.sec2') --" -ForegroundColor DarkCyan
  Write-Host "   [5] $(t 'menu.item5')   [6] $(t 'menu.item6')" -ForegroundColor Gray
  Write-Host "   [7] $(t 'menu.item7')   [8] $(t 'menu.item8')" -ForegroundColor Gray
  Write-Host "  -- $(t 'menu.sec3') --" -ForegroundColor DarkCyan
  Write-Host "   [9] $(t 'menu.item9')  [10] $(t 'menu.item10')" -ForegroundColor Gray
  Write-Host "  [11] $(t 'menu.item11')  [12] $(t 'menu.item12')" -ForegroundColor Gray
  Write-Host "  [13] $(t 'menu.item13')  [14] $(t 'menu.item14')" -ForegroundColor Gray
  Write-Host "  -- $(t 'menu.sec4') --" -ForegroundColor DarkCyan
  Write-Host "  [15] $(t 'menu.item15')  [16] $(t 'menu.item16')" -ForegroundColor Gray
  Write-Host "  [17] $(t 'menu.item17')  [18] $(t 'menu.item18')" -ForegroundColor Gray
  Write-Host "   [0] $(t 'menu.exit')`n" -ForegroundColor DarkGray
  $c = Read-Host "  $(t 'menu.choose') [0-18]"
  if ($c -eq "0") { break }
  if ($map.ContainsKey([int]$c)) { & "$PSScriptRoot\scripts\$($map[[int]$c]).ps1" } else { Write-Host "  $(t 'menu.invalid')" -ForegroundColor Red; Start-Sleep 1 }
}
