#!/usr/bin/env bash

# Get the script directory
CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Run the individual installation scripts
$CURRENT/install-brew.sh
$CURRENT/install-cask.sh
$CURRENT/install-sdk.sh
$CURRENT/install-npm.sh
$CURRENT/install-apm.sh
$CURRENT/install-pip.sh

# Start Dropbox immediately, as there's a bunch of applications
# down the line that's dependent on it's existence
open -a dropbox

# Make sure iTerm has been started once to ensure that it associates
# it's config files (necessary for osx-setup.sh)
open -a iTerm
