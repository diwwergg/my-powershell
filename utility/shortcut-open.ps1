function codei { code-insiders $args }
function docker { wsl docker $args }
function service { wsl sudo -S service $args }
function Start-Docker-Compose { wsl docker-compose $args }

Set-Alias -Name docker-compose -Value Start-Docker-Compose