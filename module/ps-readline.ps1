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