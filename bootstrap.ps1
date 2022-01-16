# As we are using mklink (via ln), this script (unfortunately) require elevated privileges
#Requires -RunAsAdministrator

Function ForceLink([string] $Source, [string] $Target) {
    if (Test-Path $Target) {
        Remove-Item -Path $Target
    }
    [void](New-Item -ItemType SymbolicLink -Path "$Target" -Target "$Source")
}

# Symlink the few files that makes sense in Windows into place...
ForceLink -Source "$PSScriptRoot\gitconfig" -Target "$HOME\.gitconfig"
#ForceLink -Source "$PSScriptRoot\config\vscode-settings.json" -Target "$HOME\AppData\Roaming\Code\User\settings.json"
#ForceLink -Source "$PSScriptRoot\config\windows-terminal-settings.json" -Target "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Configure Git
git config --file "$HOME/.gitconfig.local" credential.helper "manager-core"
git config --file "$HOME/.gitconfig.local" user.name "Henrik Hedlund"
git config --file "$HOME/.gitconfig.local" core.sshcommand "plink -agent"
git config --file "$HOME/.gitconfig.local" core.autocrlf false

$confirm = Read-Host -Prompt "Configure Git for personal use? [Y/n]"
$confirm = $confirm.Trim().ToLower()
if ($confirm -eq "yes" -or $confirm -eq "y" -or $confirm -eq "") {
    git config --file "$HOME/.gitconfig.local" user.email "henrik@hedlund.im"
}
else {
    git config --file "$HOME/.gitconfig.local" user.email "henrik.hedlund@remarkable.no"
}
