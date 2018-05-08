#!/usr/bin/env bash

if [ -z "$(which code)" ]; then
    echo "Visual Studio Code not available. Aborting!"
    exit 1
fi

# Install a bunch of useful extensions...
code --install-extension EditorConfig.EditorConfig
code --install-extension eamodio.gitlens
code --install-extension alefragnani.project-manager
code --install-extension humao.rest-client
code --install-extension alefragnani.Bookmarks
code --install-extension formulahendry.auto-close-tag
code --install-extension formulahendry.auto-rename-tag
code --install-extension wmaurer.change-case
code --install-extension christian-kohler.path-intellisense
code --install-extension cssho.vscode-svgviewer
code --install-extension bierner.color-info
code --install-extension mitchdenny.ecdc
code --install-extension flesler.url-encode
code --install-extension deerawan.vscode-dash

# ...a bunch of JavaScript stuff...
code --install-extension dbaeumer.vscode-eslint
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension esbenp.prettier-vscode
code --install-extension wix.vscode-import-cost
code --install-extension chrmarti.regex
code --install-extension christian-kohler.npm-intellisense

# ...some language support...
code --install-extension ms-vscode.cpptools
code --install-extension lukehoban.Go
code --install-extension PeterJausovec.vscode-docker
code --install-extension DotJoshJohnson.xml
code --install-extension geequlim.godot-tools
code --install-extension mauve.terraform
code --install-extension ms-vscode.PowerShell

#... and some pretty themes
code --install-extension akamud.vscode-theme-onedark
code --install-extension file-icons.file-icons
