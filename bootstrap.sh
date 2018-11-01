#!/bin/bash

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PLATFORM="$(uname -s)"
PUBLIC_GPG_KEY="93B0E5FD"

source ./functions

###############################################################################
# Symlink all the dotfiles                                                    #
###############################################################################

dotfiles=(
    aliases bash_profile bash_prompt bashrc curlrc dockerfunc exports functions gdbinit gitattributes
    gitconfig gitignore gvimrc hgignore hushlogin hyper.js inputrc nanorc path screenrc wgetrc
)
for file in "${dotfiles[@]}"; do
    ln -sf "$CURRENT/$file" "$HOME/.$file"
done;

###############################################################################
# Create GPG directory and symlink its files explicitly                       #
###############################################################################

if [ ! -d "$HOME/.gnupg" ]; then
    echo "Creating GPG directory; will ask for password..."
    mkdir "$HOME/.gnupg" && sudo chmod 700 "$HOME/.gnupg"
fi
ln -sf "$CURRENT/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"
ln -sf "$CURRENT/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

###############################################################################
# Configure GPG                                                               #
###############################################################################

if [[ ! $(gpg --list-keys) =~ $PUBLIC_GPG_KEY ]]; then
    gpg --import < "$CURRENT/config/pubkey.txt"

    prompt "Insert your Yubikey and press ENTER to continue!"
    gpg --card-status
fi

###############################################################################
# Configure Git                                                               #
###############################################################################

touch "$HOME/.gitconfig.local"
git config --file ~/.gitconfig.local user.name "Henrik Hedlund"
if confirm "Configure Git for personal use?"; then
    git config --file ~/.gitconfig.local user.email "henrik@hedlund.im"
else
    git config --file ~/.gitconfig.local user.email "henrik.hedlund@remarkable.no"
fi

sed -i "s|https://github.com/hedlund/dotfiles.git|git@github.com:hedlund/dotfiles.git|g" "$CURRENT/.git/config"

###############################################################################
# Platform specific config                                                    #
###############################################################################

if [ $PLATFORM == "Darwin" ]; then

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

    # Configure Git
    git config --file ~/.gitconfig.local credential.helper "osxkeychain"

    # Install terminal colors
    $CURRENT/config/install-terminal-colors.sh

    # Configure Spectacle
    SPECTACLE_DIR="$HOME/Library/Application Support/Spectacle"
    mkdir -p "$SPECTACLE_DIR"
    \cp "$CURRENT/config/spectacle-shortcuts.json" "$SPECTACLE_DIR/Shortcuts.json"

    # Configure VS Code
    ln -sf "$CURRENT/config/vscode-settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

elif [ $PLATFORM == "Linux" ]; then

    # Make sure nano config is available where expected
    if [ ! -d /usr/local/share/nano ]; then
        if [ -d /usr/share/nano ]; then
            sudo ln -s /usr/share/nano /usr/local/share/nano
        fi
    fi

else
    echo "Running on unknown OS."
fi
