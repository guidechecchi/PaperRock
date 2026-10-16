@echo off
chcp 65001 >nul
title PaperRock
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PaperRock.ps1"
if errorlevel 1 pause
