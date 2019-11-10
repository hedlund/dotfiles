#!/bin/bash

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PLATFORM="$(uname -s)"
PUBLIC_GPG_KEY="93B0E5FD"
PINENTRY_YUBIKEY="/usr/bin/pinentry-yubikey"

source ./functions

###############################################################################
# Symlink all the dotfiles                                                    #
###############################################################################

dotfiles=(
    aliases bash_profile bash_prompt bashrc curlrc dockerfunc exports functions gdbinit gitattributes
    gitconfig gitignore gvimrc hgignore hushlogin hyper.js inputrc nanorc path screenrc wgetrc npmrc
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

sed -i "s|https://github.com/hedlund/dotfiles\(.git\)\?|git@github.com:hedlund/dotfiles.git|g" "$CURRENT/.git/config"

###############################################################################
# Configure NPM                                                               #
###############################################################################

mkdir -p ${HOME}/.npm-packages

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

    # Make sure we have a common link to a pinentry
    if [ ! -f $PINENTRY_YUBIKEY ]; then
        sudo ln -s /usr/local/bin/pinentry-mac $PINENTRY_YUBIKEY
    fi

elif [ $PLATFORM == "Linux" ]; then

    # Make sure nano config is available where expected
    if [ -d /usr/local/share ] && [ ! -d /usr/local/share/nano ]; then
        if [ -d /usr/share/nano ]; then
            sudo ln -s /usr/share/nano /usr/local/share/nano
        fi
    fi

    # Make sure we have a common link to a pinentry
    if [ ! -f $PINENTRY_YUBIKEY ]; then
        PINENTRY=$(which pinentry-qt 2>/dev/null)
        PINENTRY=${PINENTRY:-$(which pinentry-gnome3 2>/dev/null)}
        PINENTRY=${PINENTRY:-$(which pinentry-gtk-2 2>/dev/null)}
        PINENTRY=${PINENTRY:-$(which pinentry 2>/dev/null)}
        if [ ! -z "$PINENTRY" ]; then
            sudo ln -s $PINENTRY $PINENTRY_YUBIKEY
        else
            echo "Unable to find a pinentry app to symlink..."
        fi
    fi

    # If we're NOT in WSL, do this...
    if [[ ! "$(uname -r)" =~ "Microsoft" ]]; then

        # Configure VS Code
        ln -sf "$CURRENT/config/vscode-settings.json" "$HOME/.config/Code - OSS/User/settings.json"

    fi

    # If we're on Manjaro/Arch, we need to get a few extra things into place...
    if [[ "$(uname -r)" =~ "MANJARO" ]]; then
    
        sudo systemctl start pcscd.socket
        sudo systemctl enable pcscd.socket

        # In order to use GPG with SSH, we need to stop the systemd gpg-agent service
        systemctl --user disable gpg-agent

        # But that is not enough if the damn gpg-agent socket files present
        if [ -f /etc/systemd/user/sockets.target.wants/gpg-agent.socket ]; then
            sudo rm /etc/systemd/user/sockets.target.wants/gpg*.socket
        fi
    
    # If we're on Solus, there are some things we need to do as well..
    elif command -v "eopkg" >/dev/null 2>&1; then
    
        sudo systemctl start pcscd
        sudo systemctl enable pcsc

    fi

else
    echo "Running on unknown OS."
fi
