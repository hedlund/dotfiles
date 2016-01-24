#!/usr/bin/env bash
# Install OS X applications using Homebrew Cask.

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

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
brew cask install istat-menus
brew cask install path-finder

# Install internet-related applications.
brew cask install google-chrome
brew cask install firefox
brew cask install firefoxdeveloperedition
brew cask install yakyak
brew cask install transmit
brew cask install evernote
#brew cask install fantastical

# Install developments tools.
brew cask install dash
brew cask install sourcetree

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
brew cask install pixate-studio

# Install some Docker & virtualization things.
brew cask install virtualbox
brew cask install dockertoolbox
brew cask install vagrant

# Install some other things.
brew cask install spotify
brew cask install pagico


# Remove outdated versions from the cellar.
brew cleanup && brew cask cleanup
