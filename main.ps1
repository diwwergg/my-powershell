$rootMainPath = $PSScriptRoot
$functionsFolder = "$PSScriptRoot\Functions"
if (Test-Path $functionsFolder) {
    Get-ChildItem -Path $functionsFolder -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}

Import-Module -Name posh-git -ErrorAction SilentlyContinue
if (-not (Get-Module -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
    Import-Module -Name PSReadLine
}
Import-Module "${rootMainPath}\module\lsdeluxe.ps1"
Import-Module "${rootMainPath}\module\ps-readline.ps1"
Import-Module "${rootMainPath}\module\ps-readline.ps1"
Import-Module "${rootMainPath}\module\fnm.ps1"
Import-Module "${rootMainPath}\utility\shortcut-open.ps1"


$previousOutputEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [Text.Encoding]::UTF8
try {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\space.omp.json" | Invoke-Expression
}
finally {
    [Console]::OutputEncoding = $previousOutputEncoding
}