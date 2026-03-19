# AGENTS.md

## Overview

This is a PowerShell environment customization repository. It sets up an enhanced PowerShell experience with modern CLI tools, custom aliases, and development shortcuts for Windows with WSL integration.

## Architecture

The codebase follows a simple module-based architecture:

- **main.ps1** - Entry point that initializes everything. Loads all modules and runs oh-my-posh with the Space theme.
- **setup-computer.ps1** - Automated installer using winget for all required tools.
- **module/** - PowerShell modules loaded by main.ps1:
  - `lsdeluxe.ps1` - Wraps lsd with aliases: `ls`, `la`, `ll`, `lg`, `tree`
  - `ps-readline.ps1` - PSReadLine configuration (key bindings, history, colors)
  - `fnm.ps1` - Initializes fnm for Node.js version management via `fnm env --use-on-cd`
- **utility/** - Standalone shortcuts:
  - `shortcut-open.ps1` - Functions: `codei`, `docker`, `service`, `docker-compose`
- **script/ubuntu/** - WSL Ubuntu setup scripts

## Common Commands

### Initial Setup
```powershell
.\setup-computer.ps1
```
Requires administrator privileges. Installs: lsd, oh-my-posh, posh-git, PSReadLine, fnm via winget.

### Manual Initialization
```powershell
.\main.ps1
```
Loads all modules and initializes the prompt. Add to PowerShell profile:
```powershell
Import-Module "C:\path\to\my-powershell\main.ps1"
```

### Test Individual Module
```powershell
. .\module\lsdeluxe.ps1
```

## Key Implementation Notes

- main.ps1 has a duplicate Import-Module for ps-readline.ps1 (lines 15-16)
- fnm.ps1 uses `Out-String | Invoke-Expression` to handle multi-line output from `fnm env`
- oh-my-posh init is wrapped with UTF-8 encoding change/restore to handle encoding issues
- lsd aliases use `-Force` and `AllScope` to override built-in `ls` alias
- Docker/service commands route through WSL: `wsl docker`, `wsl sudo -S service`
