# utility/eza.ps1
# Modern replacement for ls command using eza
# Install eza: winget install eza-community.eza

function ListItemShow {
    eza --icons --group-directories-first @Args
}

# Basic aliases
function la { eza -a --icons --group-directories-first @Args }
function ll { eza -l --icons --group-directories-first @Args }
function lla { eza -la --icons --group-directories-first @Args }
function l { eza --icons --group-directories-first @Args }

# Long format with headers
function llh { eza -lh --icons --group-directories-first --header @Args }

# Sort by time (newest first)
function lt { eza -l --icons --sort=modified --reverse @Args }
function lta { eza -la --icons --sort=modified --reverse @Args }

# Sort by size (largest first)
function lS { eza -l --icons --sort=size --reverse @Args }
function lSa { eza -la --icons --sort=size --reverse @Args }

# Only directories
function ld { eza -lD --icons @Args }
function lda { eza -laD --icons @Args }

# Only files
function lf { eza -lf --icons @Args }
function lfa { eza -laf --icons @Args }

# Tree view
function tree { eza --tree --level=2 --icons @Args }
function tree3 { eza --tree --level=3 --icons @Args }
function treea { eza --tree --level=2 --icons -a @Args }
function ltree { eza --tree --level=2 --long --icons @Args }

# Tree view - directories only
function treed { eza --tree --level=2 --icons --only-dirs @Args }
function treed3 { eza --tree --level=3 --icons --only-dirs @Args }
function treeda { eza --tree --level=2 --icons --only-dirs -a @Args }
function ltreed { eza --tree --level=2 --long --icons --only-dirs @Args }

# Git integration
function lg { eza -l --icons --git --group-directories-first @Args }
function lga { eza -la --icons --git --group-directories-first @Args }

# Detailed view
function lsd { eza -labgh --icons --git --group-directories-first @Args }

# Octal permissions
function lp { eza -l --icons --octal-permissions @Args }

# Check if ls alias exists and is not constant/readonly before removing
if (Test-Path Alias:ls) {
    $lsAlias = Get-Item Alias:ls -ErrorAction SilentlyContinue
    if ($lsAlias -and -not ($lsAlias.Options -match 'Constant|ReadOnly')) {
        Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    }
}

# Set ls alias
Set-Alias -Name ls -Value ListItemShow -Option AllScope -Force -ErrorAction SilentlyContinue