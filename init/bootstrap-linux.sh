#!/usr/bin/env bash

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Not running on Linux. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

# Use rcm to symlink all the dotfiles
env RCRC=$DOTFILES/rcrc rcup

# Start Docker
sudo service docker start

# Make sure the current user can run docker commands without sudo
sudo usermod -aG docker $USER

# Configure jenv
#TODO: this little routine is much smarter in the OS X version...
eval "$(jenv init -)"
for version in $(ls /usr/lib/jvm/); do
    echo "Adding new Java version: $version"
    jenv add "/usr/lib/jvm/$version/"
done
jenv rehash
jenv enable-plugin maven
jenv enable-plugin gradle
jenv enable-plugin ant
