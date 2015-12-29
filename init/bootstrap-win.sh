#!/usr/bin/env bash

if ! [[ "$(uname -s)" =~ CYGWIN*|MINGW*|MSYS* ]]; then
    echo "Not running on Windows. Aborting!"
    exit 1
fi
