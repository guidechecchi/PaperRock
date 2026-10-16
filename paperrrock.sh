#!/usr/bin/env bash
export LC_ALL=C.UTF-8 LANG=C.UTF-8
command -v pwsh >/dev/null 2>&1 || { echo "PowerShell 7 (pwsh) required: https://aka.ms/powershell"; exit 1; }
exec pwsh -NoProfile -ExecutionPolicy Bypass -File "$(cd "$(dirname "$0")" && pwd)/PaperRock.ps1"
