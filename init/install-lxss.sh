#!/usr/bin/env bash

if [ -z "$(which apt-get)" ]; then
    echo "apt-get not available. Aborting!"
    exit 1
fi

# Add the Node JS repository
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# Update apt-get
sudo apt-get update

# Install some CLI tools
sudo apt-get -y install build-essential
sudo apt-get -y install tree
sudo apt-get -y install git-flow
sudo apt-get -y install httpie
sudo apt-get -y install nodejs

# Install GnuPG
sudo apt-get -y install gnupg2 gnupg-agent scdaemon pcscd pcsc-tools
sudo ln -s /usr/bin/gpg2 /usr/local/bin/gpg
sudo ln -s /usr/bin/pinentry-curses /usr/local/bin/pinentry-yubikey

# Symlink nano config into place
sudo ln -s /usr/share/nano /usr/local/share/nano
