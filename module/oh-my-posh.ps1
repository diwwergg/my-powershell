# module/oh-my-posh.ps1
# Oh-My-Posh theme configuration and initialization

#region Theme Repository Sync Functions

function Sync-OhMyPoshThemesRepo {
    param(
        [string]$ScriptRoot = $PSScriptRoot
    )

    # This directory IS the git clone (a sparse checkout of the oh-my-posh repo's
    # "themes" folder) - themes are always read directly from here, never copied out.
    $repoDir = Join-Path $ScriptRoot "oh-my-posh\themes"
    $repoUrl = "https://github.com/JanDeDobbeleer/oh-my-posh.git"

    # Already cloned? Reuse it as-is - never re-clone once it's on disk.
    if (Test-Path (Join-Path $repoDir ".git")) {
        return $repoDir
    }

    # Check if git is available
    & git --version 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Git is not available. Cannot clone themes from GitHub."
        return $null
    }

    # Clean up a stale/partial (non-git) directory left over from a previous failed attempt
    if (Test-Path $repoDir) {
        Remove-Item -Path $repoDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "Cloning oh-my-posh themes repository (sparse, shallow clone)..." -ForegroundColor Yellow

    try {
        # Clone without checking out files yet, so only the sparse-checked-out
        # "themes" folder ever gets materialized on disk.
        $cloneResult = & git clone --depth 1 --branch main --no-checkout --filter=blob:none $repoUrl $repoDir 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Git clone failed: $($cloneResult -join ' ')"
        }

        Push-Location $repoDir
        try {
            & git sparse-checkout init --cone 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to initialize sparse-checkout"
            }

            & git sparse-checkout set themes 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to set sparse-checkout"
            }

            & git checkout main 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to checkout themes"
            }
        } finally {
            Pop-Location
        }

        $themeFiles = Get-ChildItem -Path (Join-Path $repoDir "themes") -Filter "*.omp.json" -ErrorAction SilentlyContinue
        Write-Host "Clone complete! $($themeFiles.Count) theme(s) available." -ForegroundColor Green

        return $repoDir
    } catch {
        Write-Error "Failed to clone oh-my-posh themes from GitHub: $($_.Exception.Message)"

        # Clean up the partial clone so the next run retries from scratch
        if (Test-Path $repoDir) {
            Remove-Item -Path $repoDir -Recurse -Force -ErrorAction SilentlyContinue
        }

        return $null
    }
}

#endregion Theme Repository Sync Functions

#region Theme Initialization Functions

function Initialize-OhMyPoshTheme {
    param(
        [string]$ThemeName = "amro",
        [string]$ScriptRoot = $PSScriptRoot
    )

    $repoDir = Sync-OhMyPoshThemesRepo -ScriptRoot $ScriptRoot
    if ($null -eq $repoDir) {
        Write-Warning "Themes repository is not available."
        return $null
    }

    # Always use the config straight from the cloned repo - no copying to another location.
    $themePath = Join-Path $repoDir "themes\$ThemeName.omp.json"
    if (Test-Path $themePath) {
        return $themePath
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
