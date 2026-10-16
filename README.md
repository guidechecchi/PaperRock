# 🪨 PaperRock

[![Version](https://img.shields.io/badge/version-2.0-blue)]() [![License](https://img.shields.io/badge/license-MIT-green)]() [![i18n](https://img.shields.io/badge/i18n-en%20%7C%20pt--BR%20%7C%20zh--CN-orange)]()

**Intelligent manager, recovery and automation toolkit for [Paperclip](https://paperclip.ing) + local Ollama deployments.**

PaperRock is a zero-dependency (PowerShell-only) control panel that diagnoses, backs up, restores and automates a local Paperclip instance running multi-agent organizations (e.g. "Vida OS").

## Features
- 🔍 Full diagnostic (APIs, adapters, personas, essential files, disk)
- 🩹 One-click recovery with automatic rollback
- 📦 ZIP backups with SHA256 manifest + rotation
- 📥 Integrity-validated restore with safety pre-backup
- 👻 SOUL.md / 💓 HEARTBEAT.md generators (identity & autonomy layers)
- 🧠 VRAM-aware Ollama model recommendations
- 🌍 Native i18n: English, Portuguese (BR), Chinese (Simplified)
- 🐧 Cross-platform: Windows (.bat) + Linux (.sh via pwsh)

## Quick start

### Windows
```powershell
chcp 65001
.\PaperRock.bat
```

### Linux
```bash
./paperrrock.sh
```

First run asks your language. Edit `config/settings.json` to point at your Paperclip install.

## Modules
| # | Module | Description |
|---|--------|-------------|
| 1 | Diagnostic | Full system check |
| 2 | Recovery | Fix adapters, validate paths, recreate essential files |
| 3 | Backup | ZIP with SHA256 manifest + rotation |
| 4 | Restore | Integrity-validated with safety pre-backup |
| 5 | Personas | CRUD of agent personas |
| 6 | Agents | Manage agents via Paperclip API |
| 7 | Ollama | Pull/remove models, VRAM-aware recommendations |
| 8 | Heartbeats | Create HEARTBEAT.md + schedule tasks |
| 9 | Soul Creator | Generate SOUL.md for all agents |
| 10 | Cleanup | Remove orphan workspaces, old logs |
| 11 | Health Check | Score-based system health |
| 12 | Emergency Kit | Kill processes, clear locks, full reset |
| 13 | Logs | Filter and view logs |
| 14 | Settings | Edit config via CLI |
| 15 | Dry-Run | Simulate without changes |
| 16 | HTML Report | Generate visual system report |

## Structure
```
PaperRock/
├── PaperRock.bat       # Windows launcher
├── paperrrock.sh       # Linux launcher
├── PaperRock.ps1       # Main menu
├── config/             # settings.json (user-specific)
├── i18n/               # en-US, pt-BR, zh-CN
├── scripts/            # 16 modules
├── templates/          # SOUL/HEARTBEAT templates
├── backups/            # Auto-rotated ZIP backups
├── logs/               # Centralized logs
└── reports/            # HTML reports
```

## CI/CD
GitHub Actions validates i18n key parity across all 3 languages on every push to `i18n/**`.

## License
MIT — see [LICENSE](LICENSE).

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. All `.ps1`/`.bat` must be ASCII-only; user-facing strings go in `i18n/*.json`.

Other languages: [Português](README.pt-BR.md) | [中文](README.zh-CN.md)