#!/bin/bash

if ! [[ "$(uname -s)" =~ CYGWIN*|MINGW*|MSYS* ]]; then
    echo "Not running on Windows. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Run the Powershell script
powershell -ExecutionPolicy Bypass -File "$CURRENT/setup-win.ps1"
