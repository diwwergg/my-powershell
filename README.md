# my-powershell

This repository contains PowerShell scripts and modules for customizing and enhancing the PowerShell experience.

## Structure

- **main.ps1**: The main script that initializes the environment by importing modules and setting up configurations.
- **setup-computer.ps1**: A script to automate the installation of essential tools and packages using `winget`.
- **module/**: Contains custom PowerShell modules.
  - **lsdeluxe.ps1**: Defines aliases and functions for the `lsd` command, a modern replacement for `ls`.
  - **ps-readline.ps1**: Configures `PSReadLine` with custom key bindings, history settings, and color themes.
  - **fnm.ps1**: Integrates Fast Node Manager (fnm) for Node.js version management with automatic switching.
- **utility/**: Contains utility scripts.
  - **shortcut-open.ps1**: Provides shortcuts for development tools including VS Code Insiders, Docker, and WSL services.

## Features

- **Custom Prompt**: Configured with `oh-my-posh` using the Space theme for a visually appealing and informative prompt.
- **Enhanced Shell Editing**: `PSReadLine` is customized with:
  - Custom key bindings (Tab completion, Ctrl+Space menu completion, Ctrl+Backspace word deletion)
  - History management with deduplication and incremental saving (5000 entries max)
  - Custom color scheme for syntax highlighting
- **Modern File Listing**: `lsd` integration with helpful aliases:
  - `ls` - Enhanced file listing with icons
  - `la` - List all files including hidden ones
  - `ll` - Long format listing with details
  - `lg` - Group directories first
  - `tree` - Tree view of directory structure
- **Node.js Management**: Automatic fnm integration for seamless Node.js version switching
- **Development Shortcuts**: Quick access commands for:
  - `codei` - Open in VS Code Insiders
  - `docker` - Docker commands via WSL
  - `service` - WSL service management
  - `docker-compose` - Docker Compose via WSL
- **Automatic Setup**: `setup-computer.ps1` installs all required tools including fnm, lsd, oh-my-posh, posh-git, and PSReadLine.

## Usage

### Initial Setup
1. Run `setup-computer.ps1` to install all required tools if running on a new machine.
2. Add the following line to your PowerShell profile (`$PROFILE`):
   ```powershell
   Import-Module "C:\path\to\your\my-powershell\main.ps1"
   ```
3. Restart your terminal to apply all changes.

### Manual Initialization
Alternatively, you can run `main.ps1` directly to initialize the environment for the current session:
```powershell
.\main.ps1
```

### Available Commands
After setup, you'll have access to:
- **File Navigation**: `ls`, `la`, `ll`, `lg`, `tree`
- **Development**: `codei <path>`, `docker <command>`, `docker-compose <command>`
- **System**: `service <command>` (WSL services)
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
- **PSReadLine** (`Microsoft.PowerShell-PSReadLine`) - Enhanced command-line editing
- **fnm** (`Schniz.fnm`) - Fast Node Manager for Node.js version management

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
   
   # Add this line to the profile
   Import-Module "C:\path\to\your\my-powershell\main.ps1"
   ```

4. Restart your terminal to enjoy the enhanced PowerShell experience!

## Configuration Details

### PSReadLine Settings
- **History**: Deduplication enabled, incremental saving, 5000 entries maximum
- **Key Bindings**:
  - `Tab` - Standard completion
  - `Ctrl+Space` - Menu completion
  - `Ctrl+Backspace` - Delete word backwards
- **Colors**: Custom syntax highlighting with cyan commands, green comments, yellow keywords

### Oh-My-Posh Theme
Uses the "Space" theme (`space.omp.json`) which displays:
- Current directory with Git status
- Node.js version (when in a Node project)
- Execution time for long-running commands
- Error indicators for failed commands

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
