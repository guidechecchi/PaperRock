# 🪨 PaperRock

[![版本](https://img.shields.io/badge/版本-2.0-blue)]() [![许可证](https://img.shields.io/badge/许可证-MIT-green)]() [![国际化](https://img.shields.io/badge/国际化-zh--CN%20%7C%20pt--BR%20%7C%20en-orange)]()

**[Paperclip](https://paperclip.ing) + 本地 Ollama 部署的智能管理、恢复与自动化工具包。**

零依赖（仅 PowerShell）控制面板，可诊断、备份、还原并自动化运行多代理组织（如 "Vida OS"）的本地 Paperclip 实例。

## 功能
- 🔍 完整诊断（API、适配器、角色、基本文件、磁盘）
- 🩹 一键恢复并自动回滚
- 📦 带 SHA256 清单与轮转的 ZIP 备份
- 📥 带完整性校验与安全预备份的还原
- 👻 SOUL.md / 💓 HEARTBEAT.md 生成器（身份与自主层）
- 🧠 按 VRAM 推荐 Ollama 模型
- 🌍 原生多语言：中文（简体）、葡萄牙语（巴西）、英语
- 🐧 跨平台：Windows (.bat) + Linux (.sh 通过 pwsh)

## 快速开始

### Windows
```powershell
chcp 65001
.\PaperRock.bat
```

### Linux
```bash
./paperrrock.sh
```

首次运行会询问语言。编辑 `config/settings.json` 指向您的 Paperclip 安装目录。

## 模块
| # | 模块 | 描述 |
|---|------|------|
| 1 | 诊断 | 完整系统检查 |
| 2 | 恢复 | 修复适配器、验证路径、重建基本文件 |
| 3 | 备份 | 带 SHA256 清单与轮转的 ZIP |
| 4 | 还原 | 带安全预备份的完整性校验 |
| 5 | 角色 | 管理代理角色 |
| 6 | 代理 | 通过 Paperclip API 管理代理 |
| 7 | Ollama | 拉取/删除模型，按 VRAM 推荐 |
| 8 | 心跳 | 创建 HEARTBEAT.md + 计划任务 |
| 9 | 灵魂创建器 | 为所有代理生成 SOUL.md |
| 10 | 清理 | 删除孤立工作区、旧日志 |
| 11 | 健康检查 | 基于评分的系统健康度 |
| 12 | 应急工具包 | 终止进程、清理锁、完全重置 |
| 13 | 日志 | 过滤和查看日志 |
| 14 | 设置 | 通过 CLI 编辑配置 |
| 15 | 试运行 | 不更改任何内容的模拟 |
| 16 | HTML 报告 | 生成可视化系统报告 |

## 结构
```
PaperRock/
├── PaperRock.bat       # Windows 启动器
├── paperrrock.sh       # Linux 启动器
├── PaperRock.ps1       # 主菜单
├── config/             # settings.json（用户特定）
├── i18n/               # zh-CN, pt-BR, en-US
├── scripts/            # 16 个模块
├── templates/          # SOUL/HEARTBEAT 模板
├── backups/            # 自动轮转的 ZIP 备份
├── logs/               # 集中式日志
└── reports/            # HTML 报告
```

## CI/CD
GitHub Actions 在每次推送 `i18n/**` 时验证 3 种语言间的 i18n 键一致性。

## 许可证
MIT — 见 [LICENSE](LICENSE)。

## 贡献
请参阅 [CONTRIBUTING.md](CONTRIBUTING.md) 以获取指南。

其他语言: [English](README.md) | [Português](README.pt-BR.md)