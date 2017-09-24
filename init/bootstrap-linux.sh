#!/usr/bin/env bash

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Not running on Linux. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

source ../exports
source ../functions

#-------------------------------------------------------------------------------
# Configure Docker
if exists docker; then
    # Start Docker
    sudo service docker start

    # Make sure Docker autostarts
    sudo systemctl enable docker

    # Make sure the current user can run docker commands without sudo
    sudo usermod -aG docker $USER
fi

#-------------------------------------------------------------------------------
# Autostart Dropbox
#if [ ! -f "$HOME/.config/autostart/dropbox.desktop" ]; then
#    if [ ! -d "$HOME/.config/autostart" ]; then
#        mkdir -p "$HOME/.config/autostart"
#    fi
#    sed "s@Exec=~@Exec=$HOME@g" $CURRENT/config/dropbox.desktop >$HOME/.config/autostart/dropbox.desktop
#fi

#-------------------------------------------------------------------------------
# Fix nano
if [ ! -d /usr/local/share/nano ]; then
    sudo mkdir -p /usr/local/share
    sudo ln -s /usr/share/nano /usr/local/share/nano
fi

#-------------------------------------------------------------------------------
# Import public GPG key (if needed)
if [[ ! $(gpg --list-keys) =~ $PUBLIC_GPG_KEY ]]; then
    gpg --import < $CURRENT/config/pubkey.txt
    sudo apt-get install -y scdaemon pcscd >/dev/null
    prompt "Initiating GPG. Please insert Yubikey and press ENTER to continue."
    gpg --card-status
fi
if [ ! -f /usr/local/bin/pinentry-yubikey ]; then
    sudo ln -s /usr/bin/pinentry /usr/local/bin/pinentry-yubikey
fi
