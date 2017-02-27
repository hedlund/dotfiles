#!/usr/bin/env bash

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Not running on Linux. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

exists() {
    command -v "$1" >/dev/null 2>&1
}

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
