#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

PUBLIC_GPG_KEY=93B0E5FD
CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

exists() {
    command -v "$1" >/dev/null 2>&1
}

#-------------------------------------------------------------------------------
# Make sure Homebrew is available
if ! exists brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
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
# Import public GPG key (if needed)
if [[ ! $(gpg --list-keys) =~ $PUBLIC_GPG_KEY ]]; then
    gpg --import < $CURRENT/config/pubkey.txt
fi
