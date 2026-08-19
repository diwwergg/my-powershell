if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
} else {
    Write-Warning "fnm is not installed. Skipping fnm.ps1 initialization. Install it with: winget install Schniz.fnm"
}
