#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

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
# Configure Git
git config --global credential.helper "osxkeychain"
