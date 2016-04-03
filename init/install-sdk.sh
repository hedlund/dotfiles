#!/usr/bin/env bash

# Install SDKMAN! if needed
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s http://get.sdkman.io | bash
fi

# Make SDKMAN! auto answers questions with yes
sed -i "s/sdkman_auto_answer=false/sdkman_auto_answer=true/g" "$HOME/.sdkman/etc/config"

# Source the SDKMAN! init script
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install the softwares
sdk install groovy
sdk install grails
sdk install gradle
sdk install springboot
sdk install maven
sdk install sbt
sdk install scala
sdk install kotlin

# Turn off auto answer
sed -i "s/sdkman_auto_answer=true/sdkman_auto_answer=false/g" "$HOME/.sdkman/etc/config"

# Install Conscript
#curl https://raw.githubusercontent.com/n8han/conscript/master/setup.sh | sh

# Install giter8
#$HOME/bin/cs n8han/giter8

# Init SDKMAN!
#export SDKMAN_DIR="$HOME/.sdkman"
#if [ -d "$SDKMAN_DIR" ]; then
#	[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
#fi
