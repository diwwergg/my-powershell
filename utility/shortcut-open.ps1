# utility/shortcut-open.ps1
# Shortcut functions for opening files and directories, and web search utilities

# Development shortcuts
function codei { code-insiders $args }
function docker { wsl docker $args }
function service { wsl sudo service $args }
function Start-DockerCompose { wsl DOCKER_BUILDKIT=0 COMPOSE_DOCKER_CLI_BUILD=0 docker compose $args }

Set-Alias -Name docker-compose -Value Start-DockerCompose
# Web search functions
function Open-WebSearch {
    param(
        [Parameter(Mandatory = $true)]
        [string]$UrlTemplate,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Query
    )
    $encodedQuery = [uri]::EscapeDataString(($Query -join ' '))
    Start-Process ($UrlTemplate -f $encodedQuery)
}

function google { Open-WebSearch -UrlTemplate "https://www.google.com/search?q={0}" @Args }
function duckduckgo { Open-WebSearch -UrlTemplate "https://www.duckduckgo.com/search?q={0}" @Args }
function bing { Open-WebSearch -UrlTemplate "https://www.bing.com/search?q={0}" @Args }
function youtube { Open-WebSearch -UrlTemplate "https://www.youtube.com/results?search_query={0}" @Args }
function github { Open-WebSearch -UrlTemplate "https://github.com/search?q={0}" @Args }
function stackoverflow { Open-WebSearch -UrlTemplate "https://stackoverflow.com/search?q={0}" @Args }
Set-Alias -Name so -Value stackoverflow
