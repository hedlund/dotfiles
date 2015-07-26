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
brew cask install totalfinder
#brew cask install xtrafinder
brew cask install iterm2
brew cask install appzapper
brew cask install caffeine
#brew cask install dropshare
brew cask install the-unarchiver
brew cask install chronosync
brew cask install jotta
brew cask install 1password
#brew cask install growlnotify
brew cask install expandrive

# Install internet-related applications.
brew cask install google-chrome
brew cask install firefox
brew cask install adium
brew cask install transmit
brew cask install evernote
brew cask install todoist
#brew cask install fantastical

# Install developments tools.
brew cask install sencha
brew cask install dash
brew cask install sourcetree
brew cask install postgres
brew cask install mamp
brew cask install gitup

# Install database tools
brew cask install pgadmin3
brew cask install sequel-pro
brew cask install dbeaver-enterprise

# Install IDEs and editors.
brew cask install sublime-text3
brew cask install visual-studio-code
brew cask install android-studio
brew cask install mou
brew cask install eclipse-jee

# Install Atom and some dependencies
brew cask install atom
apm install atom-typescript
apm install atom-material-ui atom-material-syntax
apm install dash

# Start Dropbox immediately, as there's a bunch of applications
# down the line that's dependent on it's existence
open -a dropbox

# Uninstall MAMP Pro and just keep MAMP.
open -a "Mamp Pro Uninstaller"

# Make sure iTerm has been started once to ensure that it associates
# it's config files (necessary for osx-setup.sh)
open -a iTerm
