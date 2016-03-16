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
# Use rcm to symlink all the dotfiles
if ! exists rcup; then
    sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
    sudo apt-get update
    sudo apt-get install rcm
fi
env RCRC=$DOTFILES/rcrc rcup

#-------------------------------------------------------------------------------
# Configure Docker
if exists docker; then
    # Start Docker
    sudo service docker start

    # Make sure Docker autostarts
    if [ "$(lsb_release -si)" == "Ubuntu"]; then
        #TODO: This'll fail on older Ubuntu versions...
        sudo systemctl enable docker
    fi

    # Make sure the current user can run docker commands without sudo
    sudo usermod -aG docker $USER
fi

#-------------------------------------------------------------------------------
# Configure jenv
#TODO: this little routine is much smarter in the OS X version...
if ! exists jenv; then
    export PATH="~/.jenv/bin:$PATH"
fi
if exists jenv; then
    eval "$(jenv init -)"
    for version in $(ls /usr/lib/jvm/); do
        echo "Adding new Java version: $version"
        jenv add "/usr/lib/jvm/$version/"
    done
    jenv rehash
    jenv enable-plugin maven
    jenv enable-plugin gradle
    jenv enable-plugin ant
fi

#-------------------------------------------------------------------------------
# Autostart Dropbox
if [ ! -f "$HOME/.config/autostart/dropbox.desktop" ]; then
    if [ ! -d "$HOME/.config/autostart" ]; then
        mkdir -p "$HOME/.config/autostart"
    fi
    sed "s@Exec=~@Exec=$HOME@g" $CURRENT/config/dropbox.desktop >$HOME/.config/autostart/dropbox.desktop
fi
