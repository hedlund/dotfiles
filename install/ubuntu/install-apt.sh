#!/bin/bash -e

# As this script not only is used for native OS installations,
# but also WSL, it should avoid installing desktop apps.

# Import helpers
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${SCRIPT_DIR}/../common/helpers.sh"

# Just make sure some basics are there
sudo apt-get install -y curl wget nano rsync telnet
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-get install -y git git-lfs
sudo apt-get install -y gpg scdaemon gnupg-agent
sudo apt-get install -y software-properties-common lsb-release

# Then install a bunch of stuff
sudo apt-get install -y ack
#sudo apt-get install -y default-jdk
sudo apt-get install -y direnv
sudo apt-get install -y golang
sudo apt-get install -y httpie
sudo apt-get install -y kpartx
sudo apt-get install -y nodejs npm
sudo apt-get install -y protobuf-compiler
sudo apt-get install -y qemu-user-static
sudo apt-get install -y ruby ruby-dev
sudo apt-get install -y shellcheck
sudo apt-get install -y snapd
sudo apt-get install -y socat
sudo apt-get install -y tig
sudo apt-get install -y tree
sudo apt-get install -y whois
sudo apt-get install -y xsel

# Some libraries that are needed down the line
sudo apt-get install -y libreadline-dev
sudo apt-get install -y libsecret-1-dev

# Docker is not needed in all environments
if [ "$1" != "--no-docker" ]; then
  if ! exists docker; then
    echo "Installing Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io 
  fi

  if ! exists docker-compose; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
fi

# Install Yarn
if ! exists yarn; then
  echo "Installing Yarn..."
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list >/dev/null
  sudo apt-get update && sudo apt-get install -y yarn
fi

# Install Google Cloud SDK
if ! exists gcloud; then
  echo "Installing Google Cloud SDK..."
  curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/google-cloud-keyring.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/google-cloud-keyring.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
  sudo apt-get update && sudo apt-get install -y google-cloud-sdk
fi

# Install Github CLI
if ! exists gh; then
  echo "Installing Github CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update && sudo apt-get install -y gh
fi

# Install Packer
if ! exists packer; then
  echo "Installing Packer..."
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /usr/share/keyrings/packer-archive-keyring.gpg >/dev/null
  sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get -y install packer
fi

# Cleanup
sudo apt-get autoremove -y