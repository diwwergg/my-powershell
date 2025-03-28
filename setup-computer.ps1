function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageId
    )
    Write-Host "Installing $PackageId via winget..."
    winget install --id $PackageId -e --silent
}

function Test-PackageInstalled {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageId
    )
    $result = winget list --id $PackageId -e 2>$null
    return $result -match $PackageId
}

# Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warning "winget is not installed. Please install winget from https://aka.ms/winget and re-run this script."
    exit 1
}

# List of package IDs from winget:
$packages = @(
    "Peltoche.lsd",                # lsd - modern replacement for ls
    "JanDeDobbeleer.OhMyPosh",       # oh-my-posh for prompt themes
    "posh-git.posh-git",           # posh-git for Git enhancements
    "Microsoft.PowerShell-PSReadLine"  # PSReadLine for shell editing
)

foreach ($pkg in $packages) {
    if (Test-PackageInstalled -PackageId $pkg) {
        Write-Host "$pkg is already installed."
    }
    else {
        Write-Host "$pkg is not installed. Installing..."
        # Install-WingetPackage -PackageId $pkg
    }
}

Write-Host "PowerShell setup is complete. Please restart your terminal for changes to take effect."