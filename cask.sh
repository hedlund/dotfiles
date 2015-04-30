#!/usr/bin/env bash

# Install OS X applications using Homebrew Cask.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Tap the versions repository (needed for Sublime Text 3)
brew tap caskroom/versions

# Install system tools.
brew cask install alfred
brew cask install dropbox
brew cask install spectacle
brew cask install xtrafinder
brew cask install iterm2
brew cask install appzapper
brew cask install caffeine
brew cask install dropshare
brew cask install the-unarchiver
brew cask install chronosync
brew cask install jotta
brew cask install 1password
#brew cask install growlnotify

# Install internet-related applications.
brew cask install google-chrome
brew cask install firefox
brew cask install adium
brew cask install transmit
#brew cask install fantastical

# Install virtualisation applications.
brew cask install virtualbox
#brew cask install parallels-desktop

# Install developments tools.
brew cask install sencha
brew cask install dash
brew cask install sourcetree
brew cask install postgres
brew cask install mamp
brew cask install vagrant
brew cask install pgadmin3

# Install IDEs and editors.
brew cask install sublime-text3
brew cask install android-studio
#brew cask install intellij-idea-ce
brew cask install mou

# Install entertainment applications.
#brew cask install spotify
#brew cask install steam

# Install misc additional applications.
#brew cask install adobe-creative-cloud
