#!/bin/bash

if ! [[ "$(uname -s)" =~ CYGWIN*|MINGW*|MSYS* ]]; then
    echo "Not running on Windows. Aborting!"
    exit 1
fi

if [ -z "$(which choco 2>/dev/null)" ]; then
    echo "Chocolatey not available. Aborting!"
    exit 1
fi

net session > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "You need to run this script in an Admin bash shell. Aborting!"
    exit 1
fi

# Install system tools.
choco install -y dropbox
choco install -y caffeine
#choco install -y 1password
choco install -y jdk8
#choco install -y hyper
#choco install -y putty
choco install -y gpg4win
choco install -y nano

# Install development tools.
choco install -y visualstudiocode
choco install -y arduino
#choco install -y androidstudio

# Install some fonts.
choco install -y sourcecodepro
