# Contributing

Thank you for your interest in contributing to PaperRock!

## Guidelines

1. **Fork and branch** (`feat/...`, `fix/...`, `docs/...`).
2. **Keep code ASCII-only**: all `.ps1` and `.bat` files must remain ASCII to avoid mojibake across codepages.
3. **Strings in i18n**: user-facing text goes in `i18n/*.json`. When adding a new string, update **ALL 3 languages** (en-US, pt-BR, zh-CN) — the CI will block your PR otherwise.
4. **Test locally** on PowerShell 5.1 and 7+.
5. **Open a PR** describing the change and languages verified.

## Code style

- Functions: `Verb-Noun` PowerShell convention
- Modules: numbered files (`01-diagnostic.ps1`, etc.)
- Menu items map to scripts in `PaperRock.ps1` `$map` hashtable

## Reporting bugs

- Include OS, PowerShell version (`$PSVersionTable`), and the output of Option 1 (Diagnostic).
- Paste relevant lines from `logs/paperrrock.log`.

## Questions?

Open a Discussion rather than an Issue for Q&A.