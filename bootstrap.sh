#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# Make sure we have the latest goodies
git pull origin master

# Use rcm to symlink all the dotfiles
env RCRC=$HOME/.dotfiles/rcrc rcup

# Use mackup to put the Dropboxed config files into place
if [ ! -f "$HOME/.mackup.cfg" ]; then
    ln -s $HOME/.dotfiles/mackup.cfg $HOME/.mackup.cfg
fi
mackup restore

# Create a Projects folder
if [ ! -d "$HOME/Projects" ]; then
	mkdir $HOME/Projects
fi

# Add IP address for boot2docker to /etc/hosts (if needed)
if ! grep -q "boot2docker" /etc/hosts; then
    read -r -p "Install boot2docker IP in /etc/hosts? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
        DOCKER_IP="$(docker-machine ip default 2>&1)"
        sudo bash -c 'echo "$DOCKER_IP	boot2docker" >> /etc/hosts'
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

# Configure jenv
eval "$(jenv init -)"
VERSIONS=$(jenv versions)
# TODO: These string checks are really not fool-proof, but they'll have to do for now...
if [[ $VERSIONS != *"1.6"* ]]; then
	jenv add /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/
fi
if [[ $VERSIONS != *"1.7"* ]]; then
	jenv add /Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home/
fi
if [[ $VERSIONS != *"1.8"* ]]; then
	jenv add /Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/
fi
jenv rehash
jenv enable-plugin maven
jenv enable-plugin gradle
jenv enable-plugin ant