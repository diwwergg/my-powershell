#region Module Imports
Import-Module -Name posh-git -ErrorAction SilentlyContinue
#endregion

#region Core Functions
function Import-ScriptsFromFolder {
    param(
        [string]$FolderPath
    )
    
    if (Test-Path $FolderPath) {
        Get-ChildItem -Path $FolderPath -Filter *.ps1 | ForEach-Object {
            Import-Module $_.FullName
        }
    }
}
#endregion

Import-ScriptsFromFolder -FolderPath "$PSScriptRoot\module"
Import-ScriptsFromFolder -FolderPath "$PSScriptRoot\utility"