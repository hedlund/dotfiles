#!/usr/bin/env bash

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Not running on Linux. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

# Use rcm to symlink all the dotfiles
env RCRC=$DOTFILES/rcrc rcup

# Start Docker
if [ -z "$(which rpm)" ]; then
    sudo systemctl start docker
    sudo systemctl enable docker
else
    sudo service docker start
    if [ "$(lsb_release -si)" == "Ubuntu"]; then
        #TODO: This'll fail on older Ubuntu versions...
        sudo systemctl enable docker
    fi
fi

# Make sure the current user can run docker commands without sudo
sudo usermod -aG docker $USER

# Configure jenv
#TODO: this little routine is much smarter in the OS X version...
if [ -z "$(which jenv)" ]; then
    export PATH="~/.jenv/bin:$PATH"
fi
eval "$(jenv init -)"
for version in $(ls /usr/lib/jvm/); do
    echo "Adding new Java version: $version"
    jenv add "/usr/lib/jvm/$version/"
done
jenv rehash
jenv enable-plugin maven
jenv enable-plugin gradle
jenv enable-plugin ant

# Autostart Dropbox
if [ ! -f "$HOME/.config/autostart/dropbox.desktop" ]; then
    if [ ! -d "$HOME/.config/autostart" ]; then
        mkdir -p "$HOME/.config/autostart"
    fi
    sed "s@Exec=~@Exec=$HOME@g" $CURRENT/config/dropbox.desktop >$HOME/.config/autostart/dropbox.desktop
fi
