#!/usr/bin/env bash

# Get the script directory
CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

case "$(uname -s)" in
    Darwin)
        $CURRENT/setup-osx.sh ;;

    Linux)
        $CURRENT/setup-linux.sh ;;

    CYGWIN*|MINGW32*|MSYS*)
        $CURRENT/setup-win.sh ;;

    *) echo "Running on unknown OS. Aborting!" ; exit 1 ;;
esac
