#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# Make sure we have the latest goodies
git pull origin master;

# Use rcm to symlink all the dotfiles
env RCRC=$HOME/.dotfiles/rcrc rcup

# Use mackup to put the Dropboxed config files into place
#mackup restore