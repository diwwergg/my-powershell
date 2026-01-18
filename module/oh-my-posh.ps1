# module/oh-my-posh.ps1
# Oh-My-Posh theme configuration and initialization

function Initialize-OhMyPoshTheme {
    param(
        [string]$ThemeName = "amro",
        [string]$ScriptRoot = $PSScriptRoot
    )
    
    $themeFile = "$ThemeName.omp.json"
    $themesDir = if ($env:POSH_THEMES_PATH) { 
        $env:POSH_THEMES_PATH 
    } else { 
        "$env:LOCALAPPDATA\Programs\oh-my-posh\themes" 
    }
    
    # Ensure themes directory exists
    if (-not (Test-Path $themesDir)) {
        try {
            New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
        } catch {
            $themesDir = "$env:USERPROFILE\.config\oh-my-posh\themes"
            if (-not (Test-Path $themesDir)) {
                New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
            }
        }
    }
    
    $themePath = Join-Path $themesDir $themeFile
    
    # Try 1: Check if theme exists in primary location
    if (Test-Path $themePath) {
        return $themePath
    }
    
    # Try 2: Search common installation locations
    $searchPaths = @(
        "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\$themeFile",
        "$env:ProgramFiles\oh-my-posh\themes\$themeFile",
        "${env:ProgramFiles(x86)}\oh-my-posh\themes\$themeFile",
        "$env:USERPROFILE\.config\oh-my-posh\themes\$themeFile",
        "$env:USERPROFILE\Documents\oh-my-posh\themes\$themeFile",
        "$ScriptRoot\themes\$themeFile",
        "$ScriptRoot\oh-my-posh\themes\$themeFile"
    )
    
    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            return $path
        }
    }
    
    # Try 3: Download from GitHub
    try {
        $themeUrl = "https://raw.githubusercontent.com/ohmyposh/oh-my-posh/main/themes/$themeFile"
        Write-Host "Downloading oh-my-posh theme '$ThemeName'..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $themeUrl -OutFile $themePath -ErrorAction Stop
        
        if (Test-Path $themePath) {
            Write-Host "Theme downloaded successfully to: $themePath" -ForegroundColor Green
            return $themePath
        }
    } catch {
        # Theme download failed
    }
    
    return $null
}

# Initialize oh-my-posh on module import
$previousOutputEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [Text.Encoding]::UTF8

try {
    # Get the main script root from the caller's scope
    # When imported from main.ps1, we need to get the parent script's directory
    $callerScriptRoot = $null
    
    # Try to get PSScriptRoot from parent scope (where main.ps1 is)
    try {
        $callerScriptRoot = (Get-Variable -Name PSScriptRoot -Scope 1 -ErrorAction SilentlyContinue).Value
    } catch {
        # If that fails, try to get it from the call stack
        $callStack = Get-PSCallStack
        if ($callStack.Count -gt 1) {
            $callerPath = $callStack[1].ScriptName
            if ($callerPath) {
                $callerScriptRoot = Split-Path -Parent $callerPath
            }
        }
    }
    
    # Fallback to module's directory if we can't find the caller's root
    $scriptRoot = if ($callerScriptRoot) { $callerScriptRoot } else { $PSScriptRoot }
    
    $themeName = if ($env:POSH_THEME_NAME) { $env:POSH_THEME_NAME } else { "amro" }
    $themeConfig = Initialize-OhMyPoshTheme -ThemeName $themeName -ScriptRoot $scriptRoot
    
    if ($themeConfig) {
        oh-my-posh init pwsh --config $themeConfig | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
        Write-Warning "oh-my-posh theme '$themeName' not found and could not be downloaded. Using default theme. Available themes: https://github.com/ohmyposh/oh-my-posh/tree/main/themes"
    }
} finally {
    [Console]::OutputEncoding = $previousOutputEncoding
}
