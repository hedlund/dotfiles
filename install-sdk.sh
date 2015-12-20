#!/usr/bin/env bash

# Install SDKMAN!
curl -s http://get.sdkman.io | bash

# Make SDKMAN! auto answers questions with yes
sed -i "s/sdkman_auto_answer=false/sdkman_auto_answer=true/g" "$HOME/.sdkman/etc/config"

# Source the SDKMAN! init script
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install the softwares
sdk install groovy
sdk install grails
sdk install gradle
sdk install springboot

# Turn off auto answer
sed -i "s/sdkman_auto_answer=true/sdkman_auto_answer=false/g" "$HOME/.sdkman/etc/config"
