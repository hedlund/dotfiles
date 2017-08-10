#!/usr/bin/env bash

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Not running on Linux. Aborting!"
    exit 1
fi

###############################################################################
# Import public GPG key (if needed)                                           #
###############################################################################

if [[ ! $(gpg2 --list-keys) =~ $PUBLIC_GPG_KEY ]]; then
    gpg2 --import < $CURRENT/config/pubkey.txt
    gpg2 --card-status
fi
