# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 2.0.x   | ✅ Yes    |
| < 2.0   | ❌ No     |

## Reporting a Vulnerability

PaperRock runs **entirely locally** and never sends data outside your machine except explicit localhost API calls to Paperclip (`127.0.0.1:3100`) and Ollama (`127.0.0.1:11434`).

**To report a vulnerability:**

1. **Do NOT open a public issue.**
2. Use GitHub's **Security Advisories** feature on this repository (private).
3. Include: affected script, reproduction steps, and potential impact.
4. We'll acknowledge within 72 hours and aim to fix within 14 days.

## What we care about

- **Path traversal** in backup/restore routines
- **Secret leakage** (settings.json, API keys) — always gitignored
- **Unintended data exfiltration** via HTTP calls
- **Privilege escalation** through scheduled tasks

## What we don't care about

- Theoretical issues with no local reproduction
- Problems in upstream Paperclip or Ollama (report those to their respective projects)