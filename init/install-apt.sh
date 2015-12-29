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
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" >> /etc/apt/sources.list.d/docker.list'

# Add the Spotify repository...
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# Add some additional repositories
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
sudo apt-get -y install rcm

# Install some development related things.
sudo apt-get -y install oracle-java6-installer
sudo apt-get -y install oracle-java7-installer
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install cmake
sudo apt-get -y install doxygen

# Install Docker
sudo apt-get -y install docker-engine
sudo apt-get -y install docker-compose

# Install Node JS
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get -y install nodejs

# Install some applications.
sudo apt-get -y install google-chrome-stable
sudo apt-get -y install sublime-text-installer
sudo apt-get -y install atom
sudo apt-get -y install wine
sudo apt-get -y install everpad
sudo apt-get -y install spotify-client
sudo apt-get -y install virtualbox virtualbox-dkms
sudo apt-get -y install vagrant

# Applications that should be installed:
#packer
#yakyak
#todoist


###############################################################################
# Ubuntu Make installs                                                        #
###############################################################################

umake android android-ndk android-studio
umake web firefox-dev visual-studio-code
umake ide eclipse

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
