#!/usr/bin/env bash

if [ -z "$(which code)" ]; then
    echo "Visual Studio Code not available. Aborting!"
    exit 1
fi

code --install-extension ms-vscode.cpptools
code --install-extension dbaeumer.vscode-eslint
code --install-extension lukehoban.Go