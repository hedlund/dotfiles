#!/usr/bin/env bash
# Install OS X command-line tools using Homebrew.

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew unless it's already installed
if [ -z "$(which brew)" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
fi

# Make sure we’re using the latest Homebrew & upgrade all installed formulae.
brew update
brew upgrade

# Tap Homebrew Cask and a few other useful repositories.
brew tap caskroom/cask
brew tap homebrew/versions
brew tap caskroom/versions

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash bash-completion2

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some OS X tools.
brew install vim --with-override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
brew install git-flow-avh
brew install imagemagick --with-webp
brew install tree
brew install rsync

brew install z
brew install zsh zsh-completions
brew install httpie

# Install security related things.
brew install gpg
brew install pinentry-mac

# Install JavaScript related things.
brew install node

# Install some backup management
brew install mackup

# Remove outdated versions from the cellar.
brew cleanup
