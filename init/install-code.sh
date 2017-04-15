#!/usr/bin/env bash

if [ -z "$(which code)" ]; then
    echo "Visual Studio Code not available. Aborting!"
    exit 1
fi

# Install a bunch of useful extensions...
code --install-extension ms-vscode.cpptools
code --install-extension lukehoban.Go
code --install-extension PeterJausovec.vscode-docker
code --install-extension felipecaputo.git-project-manager
code --install-extension dbaeumer.vscode-eslint
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension HookyQR.beautify
code --install-extension donjayamanne.githistory
code --install-extension humao.rest-client
code --install-extension EditorConfig.EditorConfig
code --install-extension alefragnani.Bookmarks

#... and some pretty themes
code --install-extension file-icons.file-icons
