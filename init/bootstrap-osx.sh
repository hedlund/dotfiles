#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

exists() {
    command -v "$1" >/dev/null 2>&1
}

#-------------------------------------------------------------------------------
# Make sure Homebrew is available
if ! exists brew; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#-------------------------------------------------------------------------------
# Use rcm to symlink all the dotfiles
if ! exists rcup; then
    brew tap thoughtbot/formulae
    brew install rcm
fi
env RCRC=$DOTFILES/rcrc rcup

#-------------------------------------------------------------------------------
# Use mackup to put the Dropboxed config files into place
if exists mackup; then
    if [ ! -f "$HOME/.mackup.cfg" ]; then
        ln -s $DOTFILES/mackup.cfg $HOME/.mackup.cfg
    fi
    mackup restore
fi

#-------------------------------------------------------------------------------
# Setup Docker Machine
if exists docker-machine; then
    # Create a local Docker machine for development
    /Applications/VirtualBox.app/Contents/MacOS/VBoxManage showvminfo default &> /dev/null
    VM_EXISTS_CODE=$?
    if [ $VM_EXISTS_CODE -eq 1 ]; then
        docker-machine rm -f default &> /dev/null
        rm -rf ~/.docker/machine/machines/default
        docker-machine create -d virtualbox --virtualbox-memory 2048 default
    fi

    # Add IP address for boot2docker to /etc/hosts (if needed)
    if ! grep -q "boot2docker" /etc/hosts; then
        read -r -p "Install boot2docker IP in /etc/hosts? [y/N] " response
        if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
            DOCKER_IP="$(docker-machine ip default 2>&1)"
            sudo bash -c 'echo "$DOCKER_IP	boot2docker" >> /etc/hosts'
        fi
    fi
fi

#-------------------------------------------------------------------------------
# Add the new bash version to /etc/shells (if needed)
if [ -f /usr/local/bin/bash ]; then
    if ! grep -q "/usr/local/bin/bash" /etc/shells; then
        read -r -p "Install new bash version to /etc/shells? [y/N] " response
        if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
            sudo bash -c 'echo "/usr/local/bin/bash" >> /etc/shells'
            chsh -s /usr/local/bin/bash
        fi
    fi
fi

#-------------------------------------------------------------------------------
# Configure jenv
if exists jenv; then
    eval "$(jenv init -)"
    if [[ "$(jenv versions)" != *"1.6"* ]]; then
        jenv add /Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/
    fi
    for version in $(ls /Library/Java/JavaVirtualMachines/); do
        if [[ $version =~ ^jdk([0-9]+\.[0-9]+\.[0-9]+)_([0-9]+)\.jdk ]]; then
            v="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
            if [ -z "$(jenv versions |grep "$v")" ]; then
                echo "Adding new Java version: $v"
                jenv add "/Library/Java/JavaVirtualMachines/$version/Contents/Home/"
            fi
        fi
    done
    jenv rehash
    jenv enable-plugin maven
    jenv enable-plugin gradle
    jenv enable-plugin ant
fi
