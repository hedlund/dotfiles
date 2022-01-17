#!/bin/bash -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${SCRIPT_DIR}/../common/helpers.sh"

sudo apt-get install -y caffeine
sudo apt-get install -y flameshot
sudo apt-get install -y fonts-firacode
sudo apt-get install -y ghostwriter
sudo apt-get install -y gnome-shell-extensions
sudo apt-get install -y gnome-sushi
#sudo apt-get install -y gnome-tweak-tool
#sudo apt-get install -y slack-desktop
sudo apt-get install -y spotify-client

# The following is needed to run the Docker daemon as non-root
sudo apt-get install -y dbus-user-session uidmap

if ! exists balena-etcher-electron; then
  echo "Installing Balena Etcher..."
  curl -1sLf "https://dl.cloudsmith.io/public/balena/etcher/gpg.70528471AFF9A051.key" | sudo apt-key add -
  echo 'deb https://dl.cloudsmith.io/public/balena/etcher/deb/ubuntu impish main' | sudo tee //etc/apt/sources.list.d/balena-etcher.list >/dev/null
  sudo apt-get update && sudo apt-get install -y balena-etcher-electron
fi

if ! exists code; then
  echo "Installing Visual Studio Code..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --output /usr/share/keyrings/microsoft-packages-archive-keyring.gpg
  echo 'deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-packages-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main' | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  sudo apt-get update && sudo apt-get install -y code
fi

if ! exists 1password; then
  echo "Installing 1Password..."
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list >/dev/null
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol >/dev/null
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  sudo apt-get update && sudo apt-get install -y 1password
fi

# This is interactive, so put it at the end
sudo apt-get install -y ttf-mscorefonts-installer
