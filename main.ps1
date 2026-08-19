try {
    Import-Module -Name posh-git -ErrorAction Stop
} catch {
    Write-Warning "Failed to load posh-git: $($_.Exception.Message)"
}

# import modules from module folder
Get-ChildItem -Path "$PSScriptRoot\module" -Filter *.ps1 | ForEach-Object {
    $moduleFile = $_
    try {
        Import-Module $moduleFile.FullName -ErrorAction Stop
    } catch {
        Write-Warning "Failed to load module '$($moduleFile.Name)': $($_.Exception.Message)"
    }
}

# import scripts from utility folder
Get-ChildItem -Path "$PSScriptRoot\utility" -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

# Set UTF-8 encoding to avoid thefuck encoding warnings
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = "utf-8"
