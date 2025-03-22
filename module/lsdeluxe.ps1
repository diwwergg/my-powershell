# utility/lsdeluxe.ps1

function ListItemShow {
    lsd -F @Args
}

function la { lsd -AF }
function ll { lsd -lAF }
function lg { lsd -F --group-dirs=first }
function tree { lsd -AF --tree }

# Check if ls alias exists and is not constant/readonly before removing
if (Test-Path Alias:ls) {
    $lsAlias = Get-Item Alias:ls -ErrorAction SilentlyContinue
    if ($lsAlias -and -not ($lsAlias.Options -match 'Constant|ReadOnly')) {
        Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    }
}
Set-Alias -Name ls -Value ListItemShow -Option AllScope -Force -ErrorAction SilentlyContinue
