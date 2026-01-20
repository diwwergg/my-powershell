Import-Module -Name posh-git -ErrorAction SilentlyContinue

# import modules from module folder
Get-ChildItem -Path "$PSScriptRoot\module" -Filter *.ps1 | ForEach-Object {
    Import-Module $_.FullName -ErrorAction SilentlyContinue
}

# import scripts from utility folder
Get-ChildItem -Path "$PSScriptRoot\utility" -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

# Set UTF-8 encoding to avoid thefuck encoding warnings
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = "utf-8"
