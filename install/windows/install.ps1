$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ("$ScriptDirectory\functions.ps1")

# In order to install Scoop and Choco, we must set the execution policy to
# allow to run remote scripts
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser -force
}

###############################################################################
# WinGet

winget install --id AgileBits.1Password
winget install --id Balena.Etcher
winget install --id Canonical.Ubuntu
winget install --id Docker.DockerDesktop
winget install --id Flameshot.Flameshot
winget install --id gerardog.gsudo
winget install --id Git.Git
winget install --id GnuPG.Gpg4win
winget install --id GoLang.Go
winget install --id Microsoft.PowerToys
winget install --id Microsoft.VisualStudioCode
winget install --id Mozilla.Firefox
winget install --id PuTTY.PuTTY
winget install --id QL-Win.QuickLook
winget install --id Spotify.Spotify
winget install --id VivaldiTechnologies.Vivaldi

###############################################################################
# Configuration

# Configure GPG
$GPG_CONFIG_FILE = "$HOME\AppData\Roaming\gnupg\gpg-agent.conf"
gpg --import "$ScriptDirectory\..\..\config\pubkey.txt"
if (![System.IO.File]::Exists($GPG_CONFIG_FILE) -Or (Get-Content $GPG_CONFIG_FILE | % { $_ -match "enable-putty-support" }) -contains $false) {
    Add-Content $GPG_CONFIG_FILE "enable-putty-support"
}

# Configure Docker to not automatically start, not track, NOT expose TCP, and use WSL2 by default.
$DOCKER_CONFIG_FILE = "$HOME\AppData\Roaming\Docker\settings.json"
if (![System.IO.File]::Exists($DOCKER_CONFIG_FILE) -Or (Get-Content $DOCKER_CONFIG_FILE) -eq $null) {
    @{autoStart = $false; analyticsEnabled = $false } | ConvertTo-Json | Out-File $DOCKER_CONFIG_FILE
}
else {
    (Get-Content $DOCKER_CONFIG_FILE) `
        -replace '"autoStart":.+$', '"autoStart": false,' `
        -replace '"analyticsEnabled":.+$', '"analyticsEnabled": false,' |
    Out-File $DOCKER_CONFIG_FILE
}

# Make sure SSH works with Git. Using plink (putty) enables Yubikey to work
[environment]::SetEnvironmentVariable('GIT_SSH', (Get-Command plink.exe).Path, 'USER')

# Pre-accept & store the Github key in Puttys cache so it works with Git commands
Write-Output 'Y' | plink -agent -v git@github.com


###############################################################################
# Common folders

New-Item -ItemType Directory -Force -Path "$HOME\Projects" | Out-Null
New-Item -ItemType Directory -Force -Path "$HOME\Temp" | Out-Null
