# Ensure PSReadLine is loaded before configuring
# PSReadLine is built-in to PowerShell, but may need to be imported
$psReadLineLoaded = $false
if (Get-Module -Name PSReadLine) {
    $psReadLineLoaded = $true
} elseif (Get-Module -ListAvailable -Name PSReadLine) {
    try {
        Import-Module -Name PSReadLine -ErrorAction Stop
        $psReadLineLoaded = $true
    } catch {
        Write-Warning "Failed to import PSReadLine: $($_.Exception.Message)"
    }
} else {
    Write-Warning "PSReadLine module is not available. Skipping ps-readline.ps1 configuration."
}

if ($psReadLineLoaded) {
    # Set custom key bindings
    Set-PSReadLineKeyHandler -Key Tab -Function Complete
    Set-PSReadLineKeyHandler -Key Ctrl+Spacebar -Function MenuComplete
    Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord

    # Change history settings
    Set-PSReadLineOption -HistoryNoDuplicates:$true
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
    Set-PSReadLineOption -MaximumHistoryCount 5000

    # Set a custom theme
    Set-PSReadLineOption -Colors @{
        Command   = 'Cyan'
        Comment   = 'Green'
        Keyword   = 'Yellow'
        String    = 'Magenta'
        Operator  = 'White'
        Parameter = 'Blue'
        Default   = 'Gray'
        Error     = 'Red'
    }
}