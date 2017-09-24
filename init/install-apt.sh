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
if [ ! -f /etc/apt/sources.list.d/google.list ]; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
fi

# Add the Docker repository...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Add the Spotify repository...
if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
fi

# Add the Node JS repository
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# Add the Yarn repository
if [ ! -f /etc/apt/sources.list.d/yarn.list ]; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
fi

# Add the Enpass repository
if [ ! -f /etc/apt/sources.list.d/enpass.list ]; then
    curl -sS https://dl.sinew.in/keys/enpass-linux.key | sudo apt-key add -
    echo "deb http://repo.sinew.in/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
fi

# Add the Visual Studio Code repository
if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
    sudo mv /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
fi

# Add the Albert, Caffeine Plus, etc repository
sudo add-apt-repository ppa:nilarimogard/webupd8

# Add the Ghostwriter repository
sudo add-apt-repository -y ppa:wereturtle/ppa

# Update apt-get
sudo apt-get update

# Install some CLI tools
sudo apt-get -y install build-essential
sudo apt-get -y install tree
sudo apt-get -y install git-flow
sudo apt-get -y install httpie
sudo apt-get -y install ubuntu-make

# Install Node
sudo apt-get -y install nodejs
sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# Install Docker
sudo apt-get -y install docker-ce
sudo apt-get -y install docker-compose

# Install some applications.
sudo apt-get -y install google-chrome-stable
sudo apt-get -y install spotify-client
sudo apt-get -y install nautilus-dropbox
sudo apt-get -y install albert
sudo apt-get -y install caffeine-plus
sudo apt-get -y install spotify-client
sudo apt-get -y install ghostwriter
sudo apt-get -y install yarn
sudo apt-get -y install enpass
sudo apt-get -y install code

# Cleanup
sudo apt-get -y autoremove && sudo apt-get clean
