# 🪨 PaperRock

[![Versão](https://img.shields.io/badge/versão-2.0-blue)]() [![Licença](https://img.shields.io/badge/licença-MIT-green)]() [![i18n](https://img.shields.io/badge/i18n-pt--BR%20%7C%20en%20%7C%20zh--CN-orange)]()

**Gerenciador inteligente, recuperação e automação para instalações locais do [Paperclip](https://paperclip.ing) + Ollama.**

PaperRock é um painel de controle sem dependências (somente PowerShell) que diagnostica, faz backup, restaura e automatiza uma instância local do Paperclip com organizações multi-agente (ex.: "Vida OS").

## Recursos
- 🔍 Diagnóstico completo (APIs, adapters, personas, arquivos essenciais, disco)
- 🩹 Recovery com rollback automático
- 📦 Backups ZIP com manifest SHA256 + rotação
- 📥 Restore com validação de integridade e pré-backup de segurança
- 👻 Geradores de SOUL.md / 💓 HEARTBEAT.md (camadas de identidade e autonomia)
- 🧠 Recomendação de modelos Ollama conforme VRAM
- 🌍 i18n nativo: Português (BR), Inglês, Chinês (Simplificado)
- 🐧 Cross-platform: Windows (.bat) + Linux (.sh via pwsh)

## Início rápido

### Windows
```powershell
chcp 65001
.\PaperRock.bat
```

### Linux
```bash
./paperrrock.sh
```

Na primeira execução o idioma é perguntado. Ajuste `config/settings.json` para apontar para seu Paperclip.

## Módulos
| # | Módulo | Descrição |
|---|--------|-----------|
| 1 | Diagnóstico | Check completo do sistema |
| 2 | Recovery | Corrigir adapters, validar paths, recriar arquivos essenciais |
| 3 | Backup | ZIP com manifest SHA256 + rotação |
| 4 | Restore | Validação de integridade com pré-backup de segurança |
| 5 | Personas | CRUD de personas de agentes |
| 6 | Agentes | Gerenciar agentes via API do Paperclip |
| 7 | Ollama | Pull/remove modelos, recomendações por VRAM |
| 8 | Heartbeats | Criar HEARTBEAT.md + agendar tarefas |
| 9 | Soul Creator | Gerar SOUL.md para todos os agentes |
| 10 | Cleanup | Remover workspaces órfãos, logs antigos |
| 11 | Health Check | Saúde do sistema baseada em score |
| 12 | Emergency Kit | Matar processos, limpar locks, reset total |
| 13 | Logs | Filtrar e visualizar logs |
| 14 | Configurações | Editar config via CLI |
| 15 | Dry-Run | Simular sem alterar nada |
| 16 | Relatório HTML | Gerar relatório visual do sistema |

## Estrutura
```
PaperRock/
├── PaperRock.bat       # Launcher Windows
├── paperrrock.sh       # Launcher Linux
├── PaperRock.ps1       # Menu principal
├── config/             # settings.json (específico por usuário)
├── i18n/               # pt-BR, en-US, zh-CN
├── scripts/            # 16 módulos
├── templates/          # Templates SOUL/HEARTBEAT
├── backups/            # Backups ZIP com rotação automática
├── logs/               # Logs centralizados
└── reports/            # Relatórios HTML
```

## CI/CD
GitHub Actions valida paridade de chaves i18n entre os 3 idiomas em todo push em `i18n/**`.

## Licença
MIT — veja [LICENSE](LICENSE).

## Contribuindo
Veja [CONTRIBUTING.md](CONTRIBUTING.md) para diretrizes.

Outros idiomas: [English](README.md) | [中文](README.zh-CN.md)