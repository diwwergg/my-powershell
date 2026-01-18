#region Module Imports
Import-Module -Name posh-git -ErrorAction SilentlyContinue

if (-not (Get-Module -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
    Import-Module -Name PSReadLine
}

Import-Module "$PSScriptRoot\module\eza.ps1"
Import-Module "$PSScriptRoot\module\ps-readline.ps1"
Import-Module "$PSScriptRoot\module\fnm.ps1"
Import-Module "$PSScriptRoot\module\oh-my-posh.ps1"
Import-Module "$PSScriptRoot\utility\shortcut-open.ps1"
Import-Module "$PSScriptRoot\utility\web-search.ps1"
#endregion

#region Function Loading
$functionsFolder = "$PSScriptRoot\Functions"
if (Test-Path $functionsFolder) {
    Get-ChildItem -Path $functionsFolder -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}
#endregion