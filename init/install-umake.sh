#!/usr/bin/env bash

if [ -z "$(which umake)" ]; then
    echo "ubuntu-make not available. Aborting!"
    exit 1
fi


#umake android android-sdk android-ndk android-studio
#umake web firefox-dev visual-studio-code
#umake ide eclipse

umake ide visual-studio-code
umake ide arduino
umake go

# Update the Android SDK
#echo "y" | $HOME/.local/share/umake/android/android-sdk/tools/android update sdk --no-ui --filter 'platform-tools'

# Make Visual Studio Code available on the path
ln -s $HOME/.local/share/umake/ide/visual-studio-code/code $HOME/.bin/