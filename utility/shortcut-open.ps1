# utility/shortcut-open.ps1
# Shortcut functions for opening files and directories, and web search utilities

# Development shortcuts
function codei { code-insiders $args }
function docker { wsl docker $args }
function service { wsl sudo -S service $args }
function Start-DockerCompose { wsl DOCKER_BUILDKIT=0 COMPOSE_DOCKER_CLI_BUILD=0 docker compose $args }

Set-Alias -Name docker-compose -Value Start-DockerCompose
# Web search functions
function google {
    $query = $args -join ' '
    Start-Process "https://www.google.com/search?q=$query"
}

function duckduckgo {
    $query = $args -join ' '
    Start-Process "https://www.duckduckgo.com/search?q=$query"
}

function bing {
    $query = $args -join ' '
    Start-Process "https://www.bing.com/search?q=$query"
}

function youtube {
    $query = $args -join ' '
    Start-Process "https://www.youtube.com/results?search_query=$query"
}

function github {
    $query = $args -join ' '
    Start-Process "https://github.com/search?q=$query"
}

function stackoverflow {
    $query = $args -join ' '
    Start-Process "https://stackoverflow.com/search?q=$query"
}