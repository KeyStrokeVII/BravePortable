@echo off
:: Quick launcher batch file for Brave Portable
:: Launches BraveLauncher.ps1 with ExecutionPolicy bypass

cd /d "%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "%~dp0BraveLauncher.ps1"
