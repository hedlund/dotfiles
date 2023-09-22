#!/bin/bash -e

function exists() {
  command -v "$1" >/dev/null 2>&1
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
    gnome-shell-extension-pop-shell \
    gnome-tweaks \
    just \
    podman-compose \
    podman-docker
  systemctl reboot
fi
