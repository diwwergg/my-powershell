# AGENTS.md

## Overview

This is a PowerShell environment customization repository. It sets up an enhanced PowerShell experience with modern CLI tools, custom aliases, and development shortcuts for Windows with WSL integration.

## Architecture

The codebase follows a simple module-based architecture:

- **main.ps1** - Entry point that initializes everything. Imports every module in `module/`, dot-sources every script in `utility/`, and sets UTF-8 console encoding.
- **setup-computer.ps1** - Automated installer using winget for all required tools.
- **module/** - PowerShell modules loaded by main.ps1 via `Import-Module`:
  - `eza.ps1` - Wraps `eza` with aliases: `ls`, `la`, `ll`, `lg`, `tree`, and many more (see file for the full list)
  - `ps-readline.ps1` - PSReadLine configuration (key bindings, history, colors)
  - `fnm.ps1` - Initializes fnm for Node.js version management via `fnm env --use-on-cd`
  - `oh-my-posh.ps1` - Ensures `oh-my-posh/themes/` (repo root) is a git sparse-checkout clone of the oh-my-posh repo's `themes` folder - clones it once and reuses it forever after (checks for `oh-my-posh/themes/.git` before cloning again), then initializes the prompt directly from the theme file inside that clone (`oh-my-posh/themes/themes/<name>.omp.json`) named by `$env:POSH_THEME_NAME` (default `amro`). Never copies theme files elsewhere.
- **utility/** - Standalone shortcuts, dot-sourced (not imported) by main.ps1:
  - `shortcut-open.ps1` - Functions: `codei`, `docker`, `service`, `docker-compose`, and web-search shortcuts `google`, `duckduckgo`, `bing`, `youtube`, `github`, `stackoverflow` (alias `so`)
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
. .\module\eza.ps1
```

## Key Implementation Notes

- main.ps1 imports modules with try/catch around `Import-Module`, so a missing dependency (posh-git, eza, fnm, oh-my-posh) produces a `Write-Warning` instead of failing silently or crashing.
- fnm.ps1, eza.ps1, and oh-my-posh.ps1 each check `Get-Command` for their underlying binary before using it, and warn (with the winget install command) if it's missing.
- fnm.ps1 uses `Out-String | Invoke-Expression` to handle multi-line output from `fnm env`
- oh-my-posh init is wrapped with UTF-8 encoding change/restore to handle encoding issues; it resolves the caller's script root by walking `Get-PSCallStack` (module-scope variable lookups via `Get-Variable -Scope N` don't reliably reach the caller when a `.ps1` is loaded via `Import-Module`)
- `oh-my-posh/themes/` is a real, persistent `git clone` (not a folder of copied files) and is gitignored; delete it to force a fresh clone on the next run
- eza aliases use `-Force` and `AllScope` to override the built-in `ls` alias
- Docker/service commands route through WSL: `wsl docker`, `wsl sudo service`
- Web-search functions in shortcut-open.ps1 URL-encode the query via `[uri]::EscapeDataString` before building the search URL
