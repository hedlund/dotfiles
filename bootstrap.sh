#!/bin/bash
set -euo pipefail

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
GIT_NAME="Henrik Hedlund"
GIT_EMAIL_PERSONAL="henrik@hedlund.im"
GIT_EMAIL_WORK="henrik.hedlund@remarkable.no"
GPG_PUBLIC_KEY="93B0E5FD"

source ./functions

###############################################################################
# Symlink all the dotfiles                                                    #
###############################################################################

dotfiles=(
  aliases bash_profile bash_prompt bashrc curlrc exports functions
  gitconfig gitignore gvimrc hushlogin inputrc nanorc path screenrc wgetrc
)
for file in "${dotfiles[@]}"; do
  ln -sf "$CURRENT/$file" "$HOME/.$file"
done;

ln -sf "$CURRENT/justfile" "$HOME/justfile"
ln -sf "$CURRENT/config/starship.toml" "$HOME/.config/starship.toml"

###############################################################################
# Create projects directory                                                   #
###############################################################################

mkdir -p "$HOME/Projects"

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

if [[ ! $(gpg --list-keys) =~ $GPG_PUBLIC_KEY ]]; then
  gpg --import < "$CURRENT/config/pubkey.txt"
fi

###############################################################################
# Configure Git                                                               #
###############################################################################

touch "$HOME/.gitconfig.local"
git config --file ~/.gitconfig.local user.name "$GIT_NAME"
if confirm "Configure Git for personal use?"; then
  git config --file ~/.gitconfig.local user.email "$GIT_EMAIL_PERSONAL"
else
  git config --file ~/.gitconfig.local user.email "$GIT_EMAIL_WORK"
fi

###############################################################################
# Add fonts                                                                   #
###############################################################################

LOCAL_FONTS="$HOME/.local/share/fonts"
if [ ! -L "$LOCAL_FONTS" ]; then
  rm -rf "$LOCAL_FONTS"
  mkdir -p "$HOME/.local/share"
  ln -sf "$CURRENT/fonts" "$LOCAL_FONTS"
fi

###############################################################################
# Platform specific config                                                    #
###############################################################################

if is_distrobox; then
  if ! exists podman; then
    echo "Linking podman to container..."
    sudo ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman
  fi
  
  if ! exists docker; then
    echo "Linking docker to container..."
    sudo ln -s /usr/bin/distrobox-host-exec /usr/local/bin/docker
  fi

  if ! exists docker-compose; then
    echo "Linking docker-compose to container..."
    sudo ln -s /usr/bin/distrobox-host-exec /usr/local/bin/docker-compose
  fi

  # if exists code; then
  #   echo "Exporting Visual Studio Code to the host..."
  #   distrobox-export --app code
  # fi

  # Symlink podman host to get VS Code working with Distrobox
  mkdir -p "$HOME/.local/bin"
  ln -sf "$CURRENT/bin/podman-host" "$HOME/.local/bin/podman-host"

elif is_wsl; then

  # Update the Git submodule to pull the wsl2-ssh-pageant repo
  git submodule init
  git submodule update

  mkdir -p "${HOME}/.ssh"
  
  # Build and install the Pageant tunnel...
  (cd "$CURRENT/wsl2-ssh-pageant" && make install)
else
  echo "Running on unknown OS."
fi
