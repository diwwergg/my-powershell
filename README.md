# my-powershell

This repository contains PowerShell scripts and modules for customizing and enhancing the PowerShell experience.

## Structure

- **main.ps1**: The main script that initializes the environment by importing modules and setting up configurations.
- **setup-computer.ps1**: A script to automate the installation of essential tools and packages using `winget`.
- **module/**: Contains custom PowerShell modules.
  - **lsdeluxe.ps1**: Defines aliases and functions for the `lsd` command, a modern replacement for `ls`.
  - **ps-readline.ps1**: Configures `PSReadLine` with custom key bindings, history settings, and color themes.
- **utility/**: Contains utility scripts.
  - **shortcut-open.ps1**: Provides a `codei` function to open files or folders in Visual Studio Code Insiders.

## Features

- **Custom Prompt**: Configured with `oh-my-posh` for a visually appealing and informative prompt.
- **Enhanced Shell Editing**: `PSReadLine` is customized for better usability with key bindings and history management.
- **Modern File Listing**: `lsd` is integrated with helpful aliases like `ls`, `la`, `ll`, and `tree`.
- **Quick Setup**: `setup-computer.ps1` automates the installation of required tools like `lsd`, `oh-my-posh`, `posh-git`, and `PSReadLine`.

## Usage

1. Run `main.ps1` to initialize the environment.
2. Use `setup-computer.ps1` to install required tools if running on a new machine.
3. Explore the modules and utilities for additional functionality.

## Requirements

- PowerShell 7+
- `winget` for package management
- Tools like `lsd`, `oh-my-posh`, `posh-git`, and `PSReadLine`

## Notes

- Restart your terminal after running `setup-computer.ps1` to apply changes.
- Customize the scripts and modules as needed to fit your workflow.
