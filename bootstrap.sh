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

sed -i "s|https://github.com/hedlund/.dotfiles\(.git\)\?|git@github.com:hedlund/.dotfiles.git|g" "$CURRENT/.git/config"

###############################################################################
# Platform specific config                                                    #
###############################################################################

if is_mac; then

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

elif is_linux; then

    # Make sure nano config is available where expected
    if [ -d /usr/local/share ] && [ ! -d /usr/local/share/nano ]; then
        if [ -d /usr/share/nano ]; then
            sudo ln -s /usr/share/nano /usr/local/share/nano
        fi
    fi

    # Make sure we have a common link to a pinentry
    if [ ! -f $PINENTRY_YUBIKEY ]; then
        PINENTRY=$(which pinentry-gnome3 2>/dev/null)
        PINENTRY=${PINENTRY:-$(which pinentry-qt 2>/dev/null)}
        PINENTRY=${PINENTRY:-$(which pinentry-gtk-2 2>/dev/null)}
        PINENTRY=${PINENTRY:-$(which pinentry 2>/dev/null)}
        if [ ! -z "$PINENTRY" ]; then
            sudo ln -s $PINENTRY $PINENTRY_YUBIKEY
        else
            echo "Unable to find a pinentry app to symlink..."
        fi
    fi

    # If we're NOT in WSL, do this...
    if ! is_wsl; then

        # Symlink the VS Code configuration. We have a couple of options here...
        # if [ -d "$HOME/.config/Code - OSS" ]; then
        #     ln -sf "$CURRENT/config/vscode-settings.json" "$HOME/.config/Code - OSS/User/settings.json"
        # elif [ -d "$HOME/.config/Code" ]; then
        #     ln -sf "$CURRENT/config/vscode-settings.json" "$HOME/.config/Code/User/settings.json"
        # else
        #     echo "ERROR! Unable to find VS Code config folder. Skipping!"
        # fi
        echo "Skip"

    fi

    # However, if we ARE in WSL, we need to do this...
    if is_wsl; then
        # Update the Git submodule to pull the wsl2-ssh-pageant repo
        git submodule init
        git submodule update

        mkdir -p "${HOME}/.ssh"
        
        # Build and install the Pageant tunnel...
        (cd "$CURRENT/wsl2-ssh-pageant" && make install)
    fi

    # There are some things we need to tweak in order the get the Yubikey to work...
    # On Manjaro and Pop!_OS (and probably more), we need to tweak the gpg-agent
    if [[ "$(uname -r)" =~ "MANJARO" ]] || [[ "$(uname -a)" =~ "pop-os" ]]; then
    
        # In order to use GPG with SSH, we need to stop the systemd gpg-agent service
        systemctl --user disable gpg-agent

        # But that is not enough if the damn gpg-agent socket files present
        if [ -f /etc/systemd/user/sockets.target.wants/gpg-agent.socket ]; then
            sudo rm /etc/systemd/user/sockets.target.wants/gpg*.socket
        fi
    fi

    # On Manjaro/Arch, we also need to start the pcscd socket
    if [[ "$(uname -r)" =~ "MANJARO" ]]; then

        sudo systemctl start pcscd.socket
        sudo systemctl enable pcscd.socket

    # On Solus, we need to do the same, but the command is slightly different
    elif command -v "eopkg" >/dev/null 2>&1; then

        sudo systemctl start pcscd
        sudo systemctl enable pcsc

    fi

else
    echo "Running on unknown OS."
fi
