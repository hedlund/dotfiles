#!/usr/bin/env bash

if [ -z "$(which apt-get)" ]; then
    echo "apt-get not available. Aborting!"
    exit 1
fi

# Install a few build necessities
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add the Google Chrome repository...
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

# Add the Docker repository...
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
sudo add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"

# Add the Dropbox repository...
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo sh -c 'echo "deb http://linux.dropbox.com/ubuntu/ $(lsb_release -cs) main" >> /etc/apt/sources.list.d/dropbox.list'

# Add the Spotify repository...
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# Add the Node JS repository
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -

# Add some additional repositories
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
#sudo add-apt-repository -y ppa:webupd8team/java

# Update apt-get
sudo apt-get update

# Install some CLI tools
sudo apt-get -y install vim
sudo apt-get -y install tree
sudo apt-get -y install imagemagick --fix-missing
sudo apt-get -y install git-flow
sudo apt-get -y install httpie
sudo apt-get -y install ubuntu-make
sudo apt-get -y install build-essential
sudo apt-get -y install nodejs

# Install GnuPG
sudo apt-get -y install gnupg2 gnupg-agent scdaemon pcscd pcsc-tools
sudo ln -s /usr/bin/gpg2 /usr/local/bin/gpg

# Install Docker
sudo apt-get -y install docker-engine
sudo apt-get -y install docker-compose

# Install some applications.
sudo apt-get -y install google-chrome-stable
sudo apt-get -y install dropbox
sudo apt-get -y install spotify-client
sudo apt-get -y install albert
sudo apt-get -y install caffeine-plus
sudo apt-get -y install spotify-client