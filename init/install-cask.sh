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

# Tap the fonts repository
brew tap caskroom/fonts

# Install system tools.
brew cask install alfred
brew cask install dropbox
brew cask install spectacle
brew cask install iterm2-beta
brew cask install appzapper
brew cask install caffeine
#brew cask install dropshare
brew cask install daisydisk
brew cask install the-unarchiver
brew cask install chronosync
#brew cask install jotta
brew cask install 1password
brew cask install expandrive
brew cask install istat-menus
brew cask install path-finder
brew cask install little-snitch
brew cask install micro-snitch
brew cask install java

# Install internet-related applications.
brew cask install google-chrome
brew cask install firefox
brew cask install firefoxdeveloperedition
brew cask install transmit
brew cask install evernote

# Install developments tools.
brew cask install dash
brew cask install gitkraken
brew cask install insomnia

# Install IDEs and editors.
brew cask install sublime-text3
brew cask install visual-studio-code
brew cask install android-studio-canary
brew cask install android-file-transfer
brew cask install pixate-studio
brew cask install webstorm

# Install some Docker & virtualization things.
brew cask install virtualbox
#brew cask install dockertoolbox
brew cask install vagrant

# Install some other things.
brew cask install spotify
brew cask install calibre

# Install some fonts
brew cask install font-inconsolata

# Remove outdated versions from the cellar.
brew cleanup && brew cask cleanup

# Start Dropbox to get the synch going as soon as possible
open -a dropbox

# Open up the Little Snitch installer
LITTLESNITCH_PATH="/opt/homebrew-cask/Caskroom/little-snitch"
if [[ "$(brew cask info little-snitch)" =~ $LITTLESNITCH_PATH/([0-9]+\.[0-9]+\.[0-9]+) ]]; then
    VERSION="${BASH_REMATCH[1]}"
    open "$LITTLESNITCH_PATH/$VERSION/Little Snitch Installer.app"
fi
