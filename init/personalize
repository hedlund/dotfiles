#!/usr/bin/env bash

###############################################################################
# Mac OS X                                                                    #
###############################################################################
if [[ "$(uname -s)" == "Darwin" ]]; then

    # Install software
    brew cask install parallels-desktop
    brew cask install intellij-idea-ce
    brew cask install adobe-creative-cloud
    brew cask install steam

    # Configure Adobe Lightroom
    # Don't try to import when detecting memory card
    defaults write com.adobe.Lightroom6 memoryCardDetectionAction -string "ImportBehavior_DoNothing"
    # Always ask for catalog on startup
    defaults write com.adobe.Lightroom6 recentLibraryBehavior20 -string "AlwaysPromptForLibrary"
fi

###############################################################################
# Mac OS X & Linux                                                            #
###############################################################################
if [[ "$(uname -s)" =~ Darwin*|Linux* ]]; then

    # rcup the personal settings
    rcup -t personal

fi

###############################################################################
# Generate SSH key                                                            #
###############################################################################

printf "\nGenerating a new SSH key..."
ssh-keygen -t rsa -b 4096 -C "henrik@hedlund.im"
