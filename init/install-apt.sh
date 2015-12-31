#!/usr/bin/env bash

if [ -z "$(which apt-get)" ]; then
    echo "apt-get not available. Aborting!"
    exit 1
fi

# Add the Google Chrome repository...
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

# Add the Docker repository...
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
case "$(lsb_release -si)" in
    Ubuntu)
        case "$(lsb_release -sr)" in
            15.10) sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" >> /etc/apt/sources.list.d/docker.list' ;;
            15.04) sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-vivid main" >> /etc/apt/sources.list.d/docker.list' ;;
            14.04) sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list' ;;
            12.04) sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" >> /etc/apt/sources.list.d/docker.list' ;;
            *)
                echo "Warning: Unknown Ubuntu version - configuring Docker like Ubuntu Wily..."
                sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" >> /etc/apt/sources.list.d/docker.list' ;;
        esac ;;
    LinuxMint)
        # Assuming our Linux Mint install is based on Ubuntu Trusty
        sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list' ;;
    *)
        echo "Warning: Unknown Linux distribution - configuring Docker like Ubuntu Wily..."
        sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" >> /etc/apt/sources.list.d/docker.list' ;;
esac

# Add the Spotify repository...
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# Add the Node JS repository
sudo apt-get -y install curl
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -

# Add some additional repositories
sudo add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make
sudo add-apt-repository -y ppa:webupd8team/atom
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
sudo add-apt-repository -y ppa:webupd8team/java
sudo add-apt-repository -y ppa:nvbn-rm/ppa
sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm

# Update apt-get
sudo apt-get update

# Install some CLI tools
sudo apt-get -y install vim
sudo apt-get -y install tree
sudo apt-get -y install imagemagick --fix-missing
sudo apt-get -y install git-flow
sudo apt-get -y install graphviz
sudo apt-get -y install tesseract-ocr
sudo apt-get -y install httpie
sudo apt-get -y install ubuntu-make
sudo apt-get -y install linux-image-extra-$(uname -r)
sudo apt-get -y install build-essential
sudo apt-get -y install apparmor lxc cgroup-lite
sudo apt-get -y install python-software-properties debconf-utils
sudo apt-get -y install rcm

# Install some development related things.
echo "oracle-java6-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get -y install oracle-java6-installer
sudo apt-get -y install oracle-java7-installer
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install cmake
sudo apt-get -y install doxygen
sudo apt-get -y install nodejs

# Install Docker
sudo apt-get -y install docker-engine
sudo apt-get -y install docker-compose

# Install some applications.
sudo apt-get -y install google-chrome-stable
sudo apt-get -y install sublime-text-installer
sudo apt-get -y install atom
sudo apt-get -y install everpad
sudo apt-get -y install spotify-client
sudo apt-get -y install virtualbox virtualbox-dkms
sudo apt-get -y install vagrant

# Install Wine
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
sudo apt-get -y install ttf-mscorefonts-installer
sudo apt-get -y install wine

#TODO: Applications that should be installed:
#packer
#yakyak
#todoist


###############################################################################
# Ubuntu Make installs                                                        #
###############################################################################

umake android android-sdk android-ndk android-studio
umake web firefox-dev visual-studio-code
umake ide eclipse

# Update the Android SDK
#TODO: This will fail if umake installs in somwhere else than in ~/.local
echo "y" | $HOME/.local/share/umake/android/android-sdk/tools/android update sdk --no-ui --filter 'platform-tools'

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
