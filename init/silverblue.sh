#!/bin/bash
set -euo pipefail

# Current directory
CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if a command exists
function exists() {
  command -v "$1" >/dev/null 2>&1
}

# Ask a yes/no question
function ask() {
  read -r -p "${1:-Are you sure?} [y/N] " response
  if [[ $response =~ ^(yes|y| ) ]]; then
    return 0
  fi
  return 1
}

# Check if script was called with flag
function has_flag() {
  if [[ " ${BASH_ARGV[@]} " =~ " $1 " ]]; then
    return 0
  fi
  return 1
}

#-------------------------------------------------------------------------------
# CONFIGURE DISTROBOX
#-------------------------------------------------------------------------------

if [ ! -f "/etc/distrobox/distrobox.conf" ]; then
  echo "Write distrobox global config..."
  sudo mkdir -p /etc/distrobox
  sudo tee -a /etc/distrobox/distrobox.conf > /dev/null <<EOT
container_always_pull="1"
container_generate_entry=1
container_manager="podman"
container_name_default="ubuntu"
container_image_default="ghcr.io/hedlund/ubuntubox:latest"
non_interactive="1"
EOT
fi

#-------------------------------------------------------------------------------
# CONFIGURE FLATPAK
#-------------------------------------------------------------------------------

if [ -z "$(flatpak remotes --user | grep flathub)" ]; then
  echo "Remove filtered Flathub..."
  sudo flatpak remote-delete flathub --force

  echo "Add Flathub repository on the user..."
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  echo "Replace existing flatpaks..."
  flatpak install --user --noninteractive --reinstall flathub $(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application | tail -n +1 )

  echo "Remove all preinstalled flatpaks..."
  flatpak remove --system --noninteractive --all
fi

#-------------------------------------------------------------------------------
# CONFIGURE RPM-OSTREE
#-------------------------------------------------------------------------------

if ! exists distrobox; then
  echo "Install OSTree layers..."
  rpm-ostree install \
    distrobox \
    fira-code-fonts \
    gnome-shell-extension-pop-shell \
    gnome-tweaks \
    gstreamer1-plugin-openh264 \
    just \
    mozilla-openh264 \
    podman-compose \
    podman-docker

  echo "Rebooting..."
  systemctl reboot
fi
