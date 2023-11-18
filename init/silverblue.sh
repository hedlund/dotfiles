#!/bin/bash
set -euo pipefail

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


#------------------------------------------------------------------------------
# CONFIGURE DISTROBOX
#------------------------------------------------------------------------------

if [ ! -f "/etc/distrobox/distrobox.conf" ]; then
  echo "Write distrobox global config..."
  sudo mkdir -p /etc/distrobox
  sudo cat <<EOT > /etc/distrobox/distrobox.conf
container_always_pull="1"
container_generate_entry=1
container_manager="podman"
container_name_default="ubuntu"
container_image_default="ghcr.io/hedlund/ubuntubox:latest"
non_interactive="1"
EOT
fi

#------------------------------------------------------------------------------
# CONFIGURE FLATPAK
#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
# CONFIGURE RPM-OSTREE
#------------------------------------------------------------------------------

if ! exists distrobox; then
  echo "Install OSTree layers..."
  rpm-ostree install \
    distrobox \
    fira-code-fonts \
    go-task \
    gnome-shell-extension-pop-shell \
    gnome-tweaks \
    just \
    podman-compose \
    podman-docker

  # if exists firefox; then
  #   echo "Remove Firefox..."
  #   rpm-ostree override remove firefox firefox-langpacks
  # fi

  echo "Rebooting..."
  systemctl reboot
fi
