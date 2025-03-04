default:
  just --list

install-flatpaks:
  #!/usr/bin/env bash
  flatpak install --user --noninteractive flathub org.gnome.Boxes
  flatpak install --user --noninteractive flathub ca.desrt.dconf-editor
  flatpak install --user --noninteractive flathub com.mattjakeman.ExtensionManager
  flatpak install --user --noninteractive flathub com.github.tchx84.Flatseal
  flatpak install --user --noninteractive flathub io.github.giantpinkrobots.flatsweep
  flatpak install --user --noninteractive flathub org.gustavoperedo.FontDownloader
  flatpak install --user --noninteractive flathub io.podman_desktop.PodmanDesktop
  flatpak install --user --noninteractive flathub net.nokyan.Resources
  flatpak install --user --noninteractive flathub com.spotify.Client
  flatpak install --user --noninteractive flathub com.visualstudio.code
  flatpak install --user --noninteractive flathub io.github.flattool.Warehouse
  flatpak install --user --noninteractive flathub runtime/org.freedesktop.Sdk.Extension.golang/x86_64/24.08
  flatpak override --user --env=FLATPAK_ENABLE_SDK_EXT=golang com.visualstudio.code
  if ! $(flatpak info com.onepassword.OnePassword >/dev/null 2>&1); then
    flatpak install --user --noninteractive https://downloads.1password.com/linux/flatpak/1Password.flatpakref
  fi
  if $(flatpak info org.gnome.eog >/dev/null 2>&1); then
    flatpak uninstall --user --noninteractive org.gnome.eog
  fi

configure-gnome:
  # Enable dark mode
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  # Configure theme
  gsettings set org.gnome.desktop.background color-shading-type 'solid'
  gsettings set org.gnome.desktop.background picture-options 'zoom'
  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
  gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/blobs-d.svg'
  gsettings set org.gnome.desktop.background primary-color '#86b6ef'
  gsettings set org.gnome.desktop.background secondary-color '#000000'
  gsettings set org.gnome.desktop.screensaver color-shading-type 'solid'
  gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
  gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
  gsettings set org.gnome.desktop.screensaver primary-color '#86b6ef'
  gsettings set org.gnome.desktop.screensaver secondary-color '#000000'
  
  # Automatic timezone
  gsettings set org.gnome.desktop.datetime automatic-timezone true
  gsettings set org.gnome.desktop.interface clock-format '24h'


  # Configure touchpad
  gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

  # Configure interface
  gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
  gsettings set org.gnome.desktop.interface show-battery-percentage true

  # Configure Ptyxis Terminal
  default_profile=$(gsettings get org.gnome.Ptyxis default-profile-uuid)
  gsettings set org.gnome.Ptyxis font-name 'FiraCode Nerd Font Mono 12'
  gsettings set org.gnome.Ptyxis use-system-font false

  # Configure Files
  dconf write "/org/gtk/gtk4/settings/file-chooser/sort-directories-first" "true"
  dconf write "/org/gtk/settings/file-chooser/clock-format" "'24h'"

install-gaming:
  #!/usr/bin/env bash
  flatpak install --user --noninteractive flathub page.kramo.Cartridges
  flatpak install --user --noninteractive flathub org.godotengine.Godot
  flatpak install --user --noninteractive flathub com.heroicgameslauncher.hgl
  flatpak install --user --noninteractive flathub io.itch.itch
  flatpak install --user --noninteractive flathub com.valvesoftware.Steam

install-nvidia-drivers:
  #!/usr/bin/env bash
  rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia
  rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1
  #systemctl reboot

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

install-syncthing:
  #!/usr/bin/env bash
  
  # Create relevant folders
  mkdir -p "${HOME}/.config/syncthing"
  mkdir -p "${HOME}/.config/containers/systemd"
  mkdir -p "${HOME}/.var/app/org.gnome.Shotwell/data"
  
  # Link config file
  ln -sf "${HOME}/.dotfiles/config/syncthing.container" "${HOME}/.config/containers/systemd/syncthing.container"

  # Start service if needed
  if [ "$(systemctl --user is-enabled syncthing.service)" = "not-found" ]; then
    echo "Starting syncthing service..."
    systemctl --user daemon-reload
    systemctl --user start syncthing.service
  fi

install-playdate:
	#!/usr/bin/env bash
	PLAYDATE_SDK_PATH="$HOME/Applications/PlaydateSDK"
	TEMP_DIR=`mktemp -d`
	echo "Downloading latest Playdate SDK..."
	curl -sL "https://download.panic.com/playdate_sdk/Linux/PlaydateSDK-latest.tar.gz" | tar -xz -C "$TEMP_DIR"
	UNPACKED_FILES=($TEMP_DIR/*)
	DOWNLOADED_DIR="${UNPACKED_FILES[0]}"
	if [ -d "$PLAYDATE_SDK_PATH" ]; then
		if cmp -s "$PLAYDATE_SDK_PATH/VERSION.txt" "$DOWNLOADED_DIR/VERSION.txt"; then
			echo "Latest version already installed..."
			rm -rf "$DOWNLOADED_DIR"
			exit 0
		fi
		echo "Removing old version..."s
		rm -rf "$PLAYDATE_SDK_PATH"
	fi
	mv "$DOWNLOADED_DIR" "$PLAYDATE_SDK_PATH"
	
	if [ ! -f "/etc/udev/rules.d/50-playdate.rules" ]; then
		echo "Install Playdate udev rule..."
		sudo cp "$PLAYDATE_SDK_PATH/Resources/50-playdate.rules" /etc/udev/rules.d/
		sudo udevadm control --reload-rules
		sudo udevadm trigger
	fi
	
	if [ ! -f "$HOME/.local/share/icons/date.play.simulator.svg" ]; then
		echo "Installing Playdate icon..."
		cp "$PLAYDATE_SDK_PATH/Resources/date.play.simulator.svg" "$HOME/.local/share/icons/date.play.simulator.svg"
	fi
	
	if [ ! -f "$HOME/.local/share/applications/ubuntu-date.play.simulator.desktop" ]; then
		echo "Installing Playdate desktop shortcut..."
		cat <<-EOF > "$HOME/.local/share/applications/ubuntu-date.play.simulator.desktop"
			[Desktop Entry]
			Name=Playdate Simulator (on ubuntu)
			Exec=/usr/bin/distrobox-enter  -n ubuntu  --   $PLAYDATE_SDK_PATH/Applications/PlaydateSDK/bin/PlaydateSimulator  %u 
			Icon=$HOME/.local/share/icons/date.play.simulator.svg
			Terminal=false
			Type=Application
			MimeType=application/x-playdate-game;x-scheme-handler/playdate-simulator
			StartupWMClass=PlaydateSimulator
			Categories=Development;
			StartupNotify=true
		EOF
	fi
	
	if [ ! -f "$HOME/.local/share/mime/application/x-playdate.xml" ]; then
		echo "Creating mime info..."
		xdg-mime install --mode user "$PLAYDATE_SDK_PATH/Resources/playdate-types.xml"
		xdg-icon-resource install --mode user --context mimetypes --size 16 "$PLAYDATE_SDK_PATH/Resources/file-icon/data-16.png" application-x-playdate
		xdg-icon-resource install --mode user --context mimetypes --size 32 "$PLAYDATE_SDK_PATH/Resources/file-icon/data-32.png" application-x-playdate
		xdg-icon-resource install --mode user --context mimetypes --size 48 "$PLAYDATE_SDK_PATH/Resources/file-icon/data-48.png" application-x-playdate
		xdg-icon-resource install --mode user --context mimetypes --size 512 "$PLAYDATE_SDK_PATH/Resources/file-icon/data-512.png" application-x-playdate
	fi

enable-podman-auto-update:
  systemctl enable --user --now podman-auto-update.timer

enable-surface-secureboot:
  echo "Remember the password you specify, you need to enter it after reboot..."
  sudo mokutil --import /usr/share/surface-secureboot/surface.cer
  echo "Reboot now to finalize importing certificate. Then re-enable Secure Boot..."

remove-surface-linux:
  #!/usr/bin/env bash
  rpm-ostree remove kernel-surface surface-secureboot iptsd libwacom-surface libwacom-surface-data \
    --install kernel-core \
    --install kernel-modules \
    --install kernel-modules-extra \
    --install libwacom \
    --install libwacom-data

generate-ssh-key:
  ssh-keygen -t ed25519-sk -C "henrik@hedlund.im"
  ssh-add -t 10m "$HOME/.ssh/id_ed25519_sk"

enable-chromium-wayland:
  #!/usr/bin/env bash
  if [ ! -f "${HOME}/.local/share/applications/chromium-browser.desktop" ]; then
    cp /usr/share/applications/chromium-browser.desktop "${HOME}/.local/share/applications/chromium-browser.desktop"
    #TODO sed the file...
  fi

reset-ostree-overrides:
  #!/usr/bin/env bash
  rpm-ostree uninstall --all
  rpm-ostree override reset --all
  
  # Also remove any custom repository config installed
  source /etc/os-release
  if [ -f "/etc/yum.repos.d/secureblue-bubblejail-fedora-${VERSION_ID}.repo" ]; then
    echo "Delete bubblejail COPR repository..."
    sudo rm "/etc/yum.repos.d/secureblue-bubblejail-fedora-${VERSION_ID}.repo"
  fi
  
upgrade-silverblue:
  # sudo ostree admin pin 0
  rpm-ostree rebase fedora:fedora/41/x86_64/silverblue
