#!/usr/bin/env bash
# Note: This only works on Fedora 22+ systems...

#TODO:  This scripts isn't finished, and the whole bootstrapping
#       probably won't work on Fedora.. I just got bored and
#       didn't finish it...

if [ -z "$(which dnf)" ]; then
    echo "dnf not available. Aborting!"
    exit 1
fi

# Update dnf
sudo dnf install -y dnf-plugins-core
sudo dnf -y update

# Add Docker repository
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# Add Google Chrome Repository
sudo tee /etc/yum.repos.d/google-chrome.repo <<-'EOF'
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

# Add Node JS Repository
sudo curl --silent --location https://rpm.nodesource.com/setup | bash -

# Add some additional repositories
sudo dnf copr enable -y seeitcoming/rcm
sudo dnf copr enable -y helber/atom
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
sudo dnf config-manager --add-repo=http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo

# Update dnf
sudo dnf -y update

# Install some CLI tools
sudo dnf install -y vim-enhanced
sudo dnf install -y tree
#imagemagick
sudo dnf install -y gitflow
sudo dnf install -y graphviz
sudo dnf install -y tesseract
sudo dnf install -y httpie
sudo dnf install -y rcm
sudo dnf install -y binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms

# Install some development related things.
#TODO: Install:
#java6
#java7
#java8
sudo dnf install -y cmake
sudo dnf install -y doxygen
sudo dnf install -y nodejs

# Install Docker
sudo ndf install -y docker-engine
sudo ndf install -y docker-compose

# Install some applications.
sudo dnf install -y google-chrome-stable
sudo dnf install -y atom
sudo dnf install -y spotify-client
sudo dnf install -y vagrant
sudo dnf install -y wine

# Install VirtualBox
sudo dnf install -y VirtualBox-5.0
/usr/lib/virtualbox/vboxdrv.sh setup
sudo usermod -a -G vboxusers $USER

#TODO: Applications that should be installed:
#sublime-editor3
#everpad
#packer
#yakyak
#todoist
#android-sdk android-ndk android-studio
#firefox-dev
#visual-studio-code
#eclipse

###############################################################################
# Fedy                                                                        #
###############################################################################

bash -c 'su -c "curl http://folkswithhats.org/fedy-installer -o fedy-installer && chmod +x fedy-installer && ./fedy-installer"'

###############################################################################
# Additional installs                                                         #
###############################################################################

# Install Conscript
curl https://raw.githubusercontent.com/n8han/conscript/master/setup.sh | sh

# Install giter8
$HOME/bin/cs n8han/giter8

# Install SDKMAN!
curl -s http://get.sdkman.io | bash

# Install jEnv
git clone https://github.com/gcuisinier/jenv.git ~/.jenv

# Install & start Dropbox
( cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - )
~/.dropbox-dist/dropboxd &
