# my-powershell

This repository contains PowerShell scripts and modules for customizing and enhancing the PowerShell experience.

## Structure

- **main.ps1**: The main script that initializes the environment by importing modules and setting up configurations.
- **setup-computer.ps1**: A script to automate the installation of essential tools and packages using `winget`.
- **module/**: Contains custom PowerShell modules.
  - **eza.ps1**: Defines aliases and functions for the `eza` command, a modern replacement for `ls` with extensive customization options.
  - **ps-readline.ps1**: Configures `PSReadLine` with custom key bindings, history settings, and color themes.
  - **fnm.ps1**: Integrates Fast Node Manager (fnm) for Node.js version management with automatic switching.
  - **oh-my-posh.ps1**: Configures and initializes oh-my-posh prompt theme engine. Automatically downloads all available themes from GitHub and stores them locally.
  - **lsdeluxe.ps1**: Alternative module using `lsd` instead of `eza` (not loaded by default).
- **utility/**: Contains utility scripts.
  - **shortcut-open.ps1**: Provides shortcuts for development tools (VS Code Insiders, Docker, WSL services) and web search functions (Google, DuckDuckGo, Bing, YouTube, GitHub, Stack Overflow).
- **script/**: Contains additional setup scripts.
  - **ubuntu/setup_ubuntu_wsl.sh**: Ubuntu WSL setup script for configuring WSL environment.
- **oh-my-posh/themes/**: Local directory containing oh-my-posh theme files (`.omp.json`). Themes are automatically downloaded from GitHub on first run.
- **Functions/**: (Optional) Custom function scripts that are automatically loaded if the folder exists.

## Features

- **Custom Prompt**: Configured with `oh-my-posh` using the "amro" theme by default (configurable via `$env:POSH_THEME_NAME`). All oh-my-posh themes are automatically downloaded from GitHub and stored locally for offline use.
- **Enhanced Shell Editing**: `PSReadLine` is customized with:
  - Custom key bindings (Tab completion, Ctrl+Space menu completion, Ctrl+Backspace word deletion)
  - History management with deduplication and incremental saving (5000 entries max)
  - Custom color scheme for syntax highlighting (cyan commands, green comments, yellow keywords, magenta strings, blue parameters, white operators, gray default, red errors)
- **Modern File Listing**: `eza` integration with extensive aliases:
  - **Basic**: `ls`, `la` (all files), `ll` (long format), `lla` (long all)
  - **Sorted**: `lt`/`lta` (by time), `lS`/`lSa` (by size)
  - **Filtered**: `ld`/`lda` (directories only), `lf`/`lfa` (files only)
  - **Tree views**: `tree`, `tree3`, `treea`, `ltree`, `treed`, `treed3`, `treeda`, `ltreed`
  - **Git integration**: `lg`, `lga` (with Git status)
  - **Advanced**: `lsd` (detailed view), `llh` (with headers), `lp` (octal permissions)
- **Node.js Management**: Automatic fnm integration for seamless Node.js version switching based on `.nvmrc` or `.node-version` files
- **Development Shortcuts**: Quick access commands for:
  - `codei` - Open in VS Code Insiders
  - `docker` - Docker commands via WSL
  - `service` - WSL service management
  - `docker-compose` - Docker Compose via WSL
- **Web Search**: Quick search functions:
  - `google <query>` - Search Google
  - `duckduckgo <query>` - Search DuckDuckGo
  - `bing <query>` - Search Bing
  - `youtube <query>` - Search YouTube
  - `github <query>` - Search GitHub
  - `so <query>` - Search Stack Overflow
- **Automatic Setup**: `setup-computer.ps1` installs all required tools including fnm, lsd, oh-my-posh, posh-git, and PSReadLine. Note: `eza` must be installed separately if using the `eza.ps1` module.

## Usage

### Initial Setup
1. Run `setup-computer.ps1` to install all required tools if running on a new machine.
2. Install `eza` separately if you want to use the eza module:
   ```powershell
   winget install eza-community.eza
   ```
3. Add the following line to your PowerShell profile (`$PROFILE`):
   ```powershell
   . "C:\path\to\your\my-powershell\main.ps1"
   ```
   Note: Use `.` (dot-source) instead of `Import-Module` since `main.ps1` is a script file, not a module.
4. Restart your terminal to apply all changes.

### Manual Initialization
Alternatively, you can run `main.ps1` directly to initialize the environment for the current session:
```powershell
.\main.ps1
```

### Available Commands
After setup, you'll have access to:
- **File Navigation**: `ls`, `la`, `ll`, `lla`, `lg`, `tree`, `lt`, `lS`, `ld`, `lf`, and many more eza aliases
- **Development**: `codei <path>`, `docker <command>`, `docker-compose <command>`
- **System**: `service <command>` (WSL services)
- **Web Search**: `google <query>`, `duckduckgo <query>`, `bing <query>`, `youtube <query>`, `github <query>`, `so <query>`
- Enhanced prompt with Git integration and Node.js version display

## Requirements

- **PowerShell 7+**
- **Windows Package Manager** (`winget`) - for automated installation
- **Windows Subsystem for Linux (WSL)** - for Docker and service commands (optional)

### Automatically Installed Tools
The following tools are automatically installed via `setup-computer.ps1`:
- **lsd** (`Peltoche.lsd`) - Modern replacement for ls with icons and colors
- **oh-my-posh** (`JanDeDobbeleer.OhMyPosh`) - Prompt theme engine
- **posh-git** (`posh-git.posh-git`) - Git integration for PowerShell
- **PSReadLine** (`Microsoft.PowerShell-PSReadLine`) - Enhanced command-line editing (also auto-installed if missing when `main.ps1` runs)
- **fnm** (`Schniz.fnm`) - Fast Node Manager for Node.js version management

**Note**: The `eza.ps1` module requires `eza` to be installed separately. Install it manually with:
```powershell
winget install eza-community.eza
```

**Note**: `lsdeluxe.ps1` is an alternative module that uses `lsd` instead of `eza`, but it's not loaded by default. To use it, replace the `eza.ps1` import in `main.ps1` with `lsdeluxe.ps1`.

## Installation

### Quick Start
1. Clone this repository:
   ```powershell
   git clone <repository-url> C:\path\to\my-powershell
   ```

2. Run the setup script as Administrator:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   .\setup-computer.ps1
   ```

3. Add to your PowerShell profile:
   ```powershell
   # Open your profile for editing
   notepad $PROFILE
   
   # Add this line to the profile (use dot-source, not Import-Module)
   . "C:\path\to\your\my-powershell\main.ps1"
   ```

4. Restart your terminal to enjoy the enhanced PowerShell experience!

## Configuration Details

### PSReadLine Settings
- **History**: Deduplication enabled, incremental saving, 5000 entries maximum
- **Key Bindings**:
  - `Tab` - Standard completion
  - `Ctrl+Space` - Menu completion
  - `Ctrl+Backspace` - Delete word backwards
- **Colors**: Custom syntax highlighting:
  - Commands: Cyan
  - Comments: Green
  - Keywords: Yellow
  - Strings: Magenta
  - Operators: White
  - Parameters: Blue
  - Default: Gray
  - Errors: Red

### Oh-My-Posh Theme
- **Default Theme**: Uses the "amro" theme (`amro.omp.json`) by default, which displays:
  - Current directory with Git status
  - Node.js version (when in a Node project)
  - Execution time for long-running commands
  - Error indicators for failed commands
- **Theme Management**: 
  - All available oh-my-posh themes are automatically downloaded from GitHub using git sparse-checkout on first run
  - Themes are stored locally in `oh-my-posh/themes/` directory for offline use
  - Change theme by setting the `$env:POSH_THEME_NAME` environment variable to any available theme name
  - If a theme is not found locally, the module will attempt to download all themes from GitHub

## Notes

- **Execution Policy**: You may need to set the execution policy to allow script execution
- **Administrator Rights**: Some installations may require administrator privileges
- **Terminal Restart**: Always restart your terminal after running `setup-computer.ps1` to apply changes
- **Customization**: All scripts and modules can be customized to fit your specific workflow needs
- **WSL Integration**: Docker and service commands require WSL to be installed and configured

## Troubleshooting

- If `winget` is not found, install it from the Microsoft Store or [GitHub releases](https://aka.ms/winget)
- For fnm issues, ensure your Node.js projects have a `.nvmrc` or `.node-version` file
- If aliases don't work, check your execution policy and ensure the profile is loaded correctly
- If `eza` commands don't work, install eza manually: `winget install eza-community.eza`
- If oh-my-posh theme doesn't load, check that the theme name is correct and that you have internet access (for automatic download). Themes are downloaded using git, so ensure git is installed and accessible
- If themes fail to download, ensure git is installed and you have internet connectivity. The module uses git sparse-checkout to efficiently download only the themes directory
- For WSL-related commands (`docker`, `service`), ensure WSL is installed and configured properly
