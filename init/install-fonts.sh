#!/usr/bin/env bash
# Install OS X fonts using Homebrew Cask.

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

# Tap the fonts repository
brew tap caskroom/fonts

# Install the fonts
brew cask install font-inconsolata