# module/oh-my-posh.ps1
# Oh-My-Posh theme configuration and initialization

#region Theme Download Functions

function Download-AllOhMyPoshThemes {
    param(
        [string]$ScriptRoot = $PSScriptRoot
    )
    
    $themesDir = Join-Path $ScriptRoot "oh-my-posh\themes"
    $repoUrl = "https://github.com/JanDeDobbeleer/oh-my-posh.git"
    $tempRepoDir = Join-Path $ScriptRoot "oh-my-posh\.temp-repo"
    
    # Ensure themes directory exists
    if (-not (Test-Path $themesDir)) {
        New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
    }
    
    # Check if themes already exist
    $existingThemes = Get-ChildItem -Path $themesDir -Filter "*.omp.json" -ErrorAction SilentlyContinue
    if ($existingThemes.Count -gt 0) {
        Write-Host "Themes directory already contains $($existingThemes.Count) theme(s). Skipping download." -ForegroundColor Cyan
        return $themesDir
    }
    
    # Check if git is available
    $gitVersion = & git --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Git is not available. Cannot download themes using git commands."
        return $null
    }
    
    Write-Host "Downloading all oh-my-posh themes from GitHub using git..." -ForegroundColor Yellow
    
    try {
        # Clean up temp directory if it exists
        if (Test-Path $tempRepoDir) {
            Remove-Item -Path $tempRepoDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Clone repository shallowly (depth 1) for faster download
        Write-Host "Cloning repository (shallow clone)..." -ForegroundColor Cyan
        $cloneResult = & git clone --depth 1 --branch main $repoUrl $tempRepoDir 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Git clone failed: $($cloneResult -join ' ')"
        }
        
        # Navigate to temp repo and set sparse-checkout to only get themes directory
        Push-Location $tempRepoDir
        try {
            # Initialize sparse-checkout
            & git sparse-checkout init --cone 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to initialize sparse-checkout"
            }
            
            # Set sparse-checkout to only include themes directory
            & git sparse-checkout set themes 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to set sparse-checkout"
            }
            
            # Checkout the themes directory
            & git checkout main 2>&1 | Out-Null
            
            $sourceThemesDir = Join-Path $tempRepoDir "themes"
            if (Test-Path $sourceThemesDir) {
                # Copy theme files to destination
                $themeFiles = Get-ChildItem -Path $sourceThemesDir -Filter "*.omp.json" -ErrorAction SilentlyContinue
                if ($themeFiles.Count -eq 0) {
                    throw "No theme files found in repository"
                }
                
                Write-Host "Copying $($themeFiles.Count) theme(s)..." -ForegroundColor Cyan
                Copy-Item -Path "$sourceThemesDir\*.omp.json" -Destination $themesDir -Force
                
                Write-Host "Download complete! Downloaded $($themeFiles.Count) theme(s)." -ForegroundColor Green
            } else {
                throw "Themes directory not found in repository"
            }
        } finally {
            Pop-Location
        }
        
        # Clean up temp repository
        Remove-Item -Path $tempRepoDir -Recurse -Force -ErrorAction SilentlyContinue
        
        return $themesDir
    } catch {
        Write-Error "Failed to download themes from GitHub: $($_.Exception.Message)"
        
        # Clean up temp repository on error
        if (Test-Path $tempRepoDir) {
            Remove-Item -Path $tempRepoDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        return $null
    }
}

#endregion Theme Download Functions

#region Theme Initialization Functions

function Initialize-OhMyPoshTheme {
    param(
        [string]$ThemeName = "amro",
        [string]$ScriptRoot = $PSScriptRoot
    )
    
    $themeFile = "$ThemeName.omp.json"
    $localThemesDir = Join-Path $ScriptRoot "oh-my-posh\themes"
    
    # Ensure local themes directory exists and has themes
    if (-not (Test-Path $localThemesDir) -or (Get-ChildItem -Path $localThemesDir -Filter "*.omp.json" -ErrorAction SilentlyContinue).Count -eq 0) {
        $downloadedDir = Download-AllOhMyPoshThemes -ScriptRoot $ScriptRoot
        if ($null -eq $downloadedDir) {
            Write-Warning "Failed to download themes from GitHub."
            return $null
        }
    }
    
    # Check local themes directory (downloaded from GitHub)
    $localThemePath = Join-Path $localThemesDir $themeFile
    if (Test-Path $localThemePath) {
        return $localThemePath
    }
    
    return $null
}

#endregion Theme Initialization Functions

#region Module Initialization

# Initialize oh-my-posh on module import
$previousOutputEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [Text.Encoding]::UTF8

try {
    if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
        Write-Warning "oh-my-posh is not installed. Skipping prompt initialization. Install it with: winget install JanDeDobbeleer.OhMyPosh"
    } else {
        # Get the main script's directory (e.g. where main.ps1 lives) by walking the
        # call stack for the first frame that isn't this module file itself.
        # (Get-Variable -Scope N walks lexical scopes, not the call stack, so it does not
        # reliably reach the caller's PSScriptRoot when this file is loaded via Import-Module.)
        $callerScriptRoot = $null
        foreach ($frame in Get-PSCallStack) {
            if ($frame.ScriptName -and $frame.ScriptName -ne $PSCommandPath) {
                $callerScriptRoot = Split-Path -Parent $frame.ScriptName
                break
            }
        }

        # Fallback to this module's own directory if we can't find the caller's root
        $scriptRoot = if ($callerScriptRoot) { $callerScriptRoot } else { $PSScriptRoot }

        $themeName = if ($env:POSH_THEME_NAME) { $env:POSH_THEME_NAME } else { "amro" }
        $themeConfig = Initialize-OhMyPoshTheme -ThemeName $themeName -ScriptRoot $scriptRoot

        if ($themeConfig) {
            oh-my-posh init pwsh --config $themeConfig | Invoke-Expression
        } else {
            oh-my-posh init pwsh | Invoke-Expression
            Write-Warning "oh-my-posh theme '$themeName' not found and could not be downloaded. Using default theme. Available themes: https://github.com/JanDeDobbeleer/oh-my-posh/tree/main/themes"
        }
    }
} finally {
    [Console]::OutputEncoding = $previousOutputEncoding
}

#endregion Module Initialization
