#!/usr/bin/env bash

# Get the script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Run the individual installation scripts
$DIR/install-brew.sh
$DIR/install-cask.sh
$DIR/install-gvm.sh
$DIR/install-npm.sh

# Start Dropbox immediately, as there's a bunch of applications
# down the line that's dependent on it's existence
open -a dropbox

# Uninstall MAMP Pro and just keep MAMP.
open -a "Mamp Pro Uninstaller"

# Make sure iTerm has been started once to ensure that it associates
# it's config files (necessary for osx-setup.sh)
open -a iTerm