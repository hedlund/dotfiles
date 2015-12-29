#!/usr/bin/env bash

###############################################################################
# Mac OS X                                                                    #
###############################################################################
if [[ "$(uname -s)" == "Darwin" ]]; then

    # Install software
    brew cask install hipchat
    #brew cask install intellij-idea

    # rcup the work settings
    rcup -t work
fi

###############################################################################
# Generate SSH key                                                            #
###############################################################################

printf "\nGenerating a new SSH key..."
ssh-keygen -t rsa -b 4096 -C "henrik.hedlund@knowit.no"
