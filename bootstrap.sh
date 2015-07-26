#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# Make sure we have the latest goodies
git pull origin master

# Use rcm to symlink all the dotfiles
env RCRC=$HOME/.dotfiles/rcrc rcup

# Use mackup to put the Dropboxed config files into place
ln -s $HOME/.dotfiles/mackup.cfg $HOME/.mackup.cfg
mackup restore

# Create a Projects folder
mkdir ~/Projects

# Add IP address for boot2docker to /etc/hosts (if needed)
if ! grep -q "boot2docker" /etc/hosts; then
    read -r -p "Install boot2docker IP in /etc/hosts? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo bash -c 'echo "192.168.59.103	boot2docker" >> /etc/hosts'
    fi
fi

# Add the new bash version to /etc/shells (if needed)
if ! grep -q "/usr/local/bin/bash" /etc/shells; then
    read -r -p "Install new bash version to /etc/shells? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo bash -c 'echo "/usr/local/bin/bash" >> /etc/shells'
        chsh -s /usr/local/bin/bash
    fi
fi
