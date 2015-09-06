#!/usr/bin/env bash

# Install GVM
curl -s get.gvmtool.net | bash

# Make GVM auto answers questions with yes
sed -i "s/gvm_auto_answer=false/gvm_auto_answer=true/g" "$HOME/.gvm/etc/config"

# Source the GVM init script
source "$HOME/.gvm/bin/gvm-init.sh"

# Install the softwares
gvm install groovy
gvm install grails
gvm install gradle
gvm install springboot

# Turn off auto answer
sed -i "s/gvm_auto_answer=true/gvm_auto_answer=false/g" "$HOME/.gvm/etc/config"