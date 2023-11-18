default:
  just --list

install-flatpaks:
  #!/usr/bin/env bash
  flatpak install --user --noninteractive flathub com.raggesilver.BlackBox
  flatpak install --user --noninteractive flathub org.gnome.Boxes
  flatpak install --user --noninteractive flathub com.mattjakeman.ExtensionManager
  flatpak install --user --noninteractive flathub com.github.tchx84.Flatseal
  flatpak install --user --noninteractive flathub io.github.giantpinkrobots.flatsweep
  flatpak install --user --noninteractive flathub org.gustavoperedo.FontDownloader
  flatpak install --user --noninteractive flathub net.nokyan.Resources
  flatpak install --user --noninteractive flathub com.spotify.Client
  flatpak install --user --noninteractive flathub com.visualstudio.code
  flatpak install --user --noninteractive flathub io.github.flattool.Warehouse
  flatpak install --user --noninteractive flathub runtime/org.freedesktop.Sdk.Extension.golang/x86_64/22.08
  if ! $(flatpak info com.onepassword.OnePassword >/dev/null 2>&1); then
    flatpak install --user --noninteractive https://downloads.1password.com/linux/flatpak/1Password.flatpakref
  fi
  flatpak override --user --env=FLATPAK_ENABLE_SDK_EXT=golang com.visualstudio.code
  # flatpak install --user --noninteractive flathub org.mozilla.firefox
  flatpak uninstall --user --noninteractive org.gnome.eog

configure-gnome:
  # Enable dark mode
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  # Configure theme
  gsettings set org.gnome.desktop.background color-shading-type 'solid'
  gsettings set org.gnome.desktop.background picture-options 'zoom'
  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/drool-l.svg'
  gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/drool-d.svg'
  gsettings set org.gnome.desktop.background primary-color '#86b6ef'
  gsettings set org.gnome.desktop.background secondary-color '#000000'
  gsettings set org.gnome.desktop.screensaver color-shading-type 'solid'
  gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
  gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/gnome/drool-l.svg'
  gsettings set org.gnome.desktop.screensaver primary-color '#86b6ef'
  gsettings set org.gnome.desktop.screensaver secondary-color '#000000'
  
  # Automatic timezone
  gsettings set org.gnome.desktop.datetime automatic-timezone true

  # Configure touchpad
  gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

  # Configure interface
  gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
  gsettings set org.gnome.desktop.interface show-battery-percentage true

install-surface-linux:
  #!/usr/bin/env bash
  if [ ! -f /etc/yum.repos.d/linux-surface.repo ]; then
    echo "Installing Surface linux repository..."
    sudo wget -O /etc/yum.repos.d/linux-surface.repo https://pkg.surfacelinux.com/fedora/linux-surface.repo
  fi
  echo "Create temporary directory..."
  TEMP_DIR=`mktemp -d`
  cd "$TEMP_DIR"

  echo "Download and install kernel dummy package..."
  curl -O -L https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm
  rpm-ostree override replace ./*.rpm \
    --remove kernel-core \
    --remove kernel-modules \
    --remove kernel-modules-extra \
    --remove libwacom \
    --remove libwacom-data \
    --install kernel-surface \
    --install iptsd \
    --install libwacom-surface \
    --install libwacom-surface-data

  echo "Cleanup temporary directory..."
  rm -rf "$TEMP_DIR"

  echo "Installing Surface Secureboot..."
  rpm-ostree install surface-secureboot
  
  echo "Reboot your PC, and disable Secure Boot..."
  echo "After reboot, run 'just enable-surface-secureboot'"

enable-surface-secureboot:
  echo "Remember the password you specify, you need to enter it after reboot..."
  sudo mokutil --import /usr/share/surface-secureboot/surface.cer
  echo "Reboot now to finalize imprting certificate. Then re-enable Secure Boot..."

generate-ssh-key:
  ssh-keygen -t ed25519-sk -C "henrik@hedlund.im"
  ssh-add -t 10m "$HOME/.ssh/id_ed25519_sk"

reset-ostree-overrides:
  rpm-ostree uninstall --all
  rpm-ostree override reset --all
