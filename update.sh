#!/usr/bin/env bash

CASKROOM="/opt/homebrew-cask/Caskroom/"

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Let's check for some general upgrades first
if [ -n "$(brew list |grep php55)" ]; then
	echo "Upgrading PHP 5.5 to 7.0..."
	brew uninstall php55 php55-imagick php55-mcrypt
	brew install homebrew/php/php70 --with-gmp
	brew install php70-imagick php70-mcrypt
fi

# Un- and re-tap the caskroom/versions as that can trigger an error otherwise
brew untap caskroom/versions
brew tap caskroom/versions

# Update Homebrew 
brew update
brew cask update
brew upgrade --all

# Update Casks
for app in $(brew cask list); do
	if [ -n "$(brew cask info $app |grep "Not installed")" ]; then
		echo "Updating $app..."
		for version in $(ls "$CASKROOM/$app"); do
			echo "    Removing version $version"
			rm -rf "$CASKROOM/$app/$version"
		done
		echo "    Reinstalling latest version"
		brew cask install "$app"
	fi
done

# Cleanup Homebrew & Casks
brew cleanup
brew cask cleanup

# Update the Android SDK
echo "y" | android update sdk --no-ui --filter 'platform-tools'

# Register potential new Java versions with jenv
for version in $(ls /Library/Java/JavaVirtualMachines/); do
	if [[ $version =~ ^jdk([0-9]+\.[0-9]+\.[0-9]+)_([0-9]+)\.jdk ]]; then
		v="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
		if [ -z "$(jenv versions |grep "$v")" ]; then
			echo "Adding new Java version: $v"
			jenv add "/Library/Java/JavaVirtualMachines/$version/Contents/Home/"
		fi
	fi
done
jenv rehash

# Uninstall MAMP Pro and just keep MAMP.
# TODO: If MAMP hasn't been updated this'll fail...
open -a "Mamp Pro Uninstaller"