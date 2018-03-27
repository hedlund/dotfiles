#!/usr/bin/env bash
# Install OS X applications using Homebrew Cask.

CASKROOM_PATH="/usr/local/Caskroom"

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re up to date
brew update && brew upgrade

# Tap a few extra repositories
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap caskroom/versions

# Install system tools.
brew cask install alfred
brew cask install dropbox
brew cask install spectacle
brew cask install iterm2
brew cask install appzapper
brew cask install caffeine
brew cask install daisydisk
brew cask install the-unarchiver
brew cask install 1password
brew cask install istat-menus
brew cask install little-snitch
brew cask install micro-snitch
brew cask install java
brew cask install etcher

# Install internet-related applications.
brew cask install google-chrome
brew cask install firefox-developer-edition

# Install developments tools.
brew cask install visual-studio-code
brew cask install arduino
brew cask install now
brew cask install postman
brew cask install google-cloud-sdk

# Install some Docker & virtualization things.
brew cask install virtualbox
brew cask install docker

# Install some other things.
brew cask install spotify
brew cask install slack

# Install some fonts.
brew cask install font-inconsolata

# Remove outdated versions from the cellar.
brew cleanup && brew cask cleanup

# Things that have been removed from these lists for now
#brew cask install dash
#brew cask install hyper
#brew cask install transmit
#brew cask install android-studio

# Start a few applications to get the config started
open -a Dropbox
open -a Docker
open -a "1Password 6"
open -a "iStat Menus"
open -a "Micro Snitch"
open -a Arduino

# Open up the Little Snitch installer
LITTLESNITCH_PATH="$CASKROOM_PATH/little-snitch"
if [[ "$(brew cask info little-snitch)" =~ $LITTLESNITCH_PATH/([0-9]+\.[0-9]+\.?[0-9]*) ]]; then
    VERSION="${BASH_REMATCH[1]}"
    open "$LITTLESNITCH_PATH/$VERSION/LittleSnitch-$VERSION.dmg"
fi

# On macOS Sierra accessibility mode cannot be enabled automatically
open /System/Library/PreferencePanes/Security.prefPane/
printf "\nRemember to enable Accessibility access for the following applications:\n"
printf "    Alfred 3\n"
printf "    Dropbox\n"
printf "    Spectacle\n"
printf "Go to System Preferences > Security & Privacy > Privacy > Accessibility\n\n"

printf "Login to 1Password to get the passwords syncing.\n"
printf "Login to Dropbox and let it finish the first sync.\n"
printf "Then install Little Snitch and let it restart the computer...\n\n"

printf "VirtualBox can not be installed complete automatically, so run it's command manually:\n"
printf "    brew cask install virtualbox\n\n"
