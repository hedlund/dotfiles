#!/usr/bin/env bash

# Install OS X applications for a work setup.
# Run this after install-brew.sh and install-cask.sh.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install IDEs and editors.
brew cask install intellij-idea

# Run rcup with the work settings
rcup -t work

# Generate SSH key
printf "\nGenerating a new SSH key..."
ssh-keygen -t rsa -b 4096 -C "henrik.hedlund@knowit.no"