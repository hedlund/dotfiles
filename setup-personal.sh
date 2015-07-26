#!/usr/bin/env bash

# Install OS X applications for a personal setup.
# Run this after install-brew.sh and install-cask.sh.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Install software                                                            #
###############################################################################

brew cask install parallels-desktop
brew cask install intellij-idea-ce
brew cask install adobe-creative-cloud
brew cask install spotify
brew cask install steam

###############################################################################
# Adobe Lightroom                                                             #
###############################################################################

# Don't try to import when detecting memory card
defaults write com.adobe.Lightroom6 memoryCardDetectionAction -string "ImportBehavior_DoNothing"

# Always ask for catalog on startup
defaults write com.adobe.Lightroom6 recentLibraryBehavior20 -string "AlwaysPromptForLibrary"

###############################################################################
# rcup the personal settings                                                  #
###############################################################################

rcup -t personal

###############################################################################
# Generate SSH key                                                            #
###############################################################################

printf "\nGenerating a new SSH key..."
ssh-keygen -t rsa -b 4096 -C "henrik@hedlund.im"