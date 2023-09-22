default:
  just --list

install-flatpaks:
  flatpak install --user --noninteractive flathub com.raggesilver.BlackBox
  flatpak install --user --noninteractive flathub org.gnome.Boxes
  flatpak install --user --noninteractive flathub com.mattjakeman.ExtensionManager
  flatpak install --user --noninteractive flathub com.github.tchx84.Flatseal
  flatpak install --user --noninteractive flathub org.gustavoperedo.FontDownloader
  flatpak install --user --noninteractive flathub com.spotify.Client
  flatpak install --user --noninteractive flathub com.visualstudio.code
  flatpak install --user --noninteractive https://downloads.1password.com/linux/flatpak/1Password.flatpakref

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
  
generate-ssh-key:
  ssh-keygen -t ed25519-sk -C "henrik@hedlund.im"
  ssh-add -t 10m "$HOME/.ssh/id_ed25519_sk"

