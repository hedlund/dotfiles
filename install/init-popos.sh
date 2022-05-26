#!/bin/bash -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Install the Ubuntu basics
${SCRIPT_DIR}/ubuntu/install-apt.sh

# Install stuff from the Pop OS repos
${SCRIPT_DIR}/popos/install-apt.sh

# Install some more snaps
${SCRIPT_DIR}/popos/install-snap.sh

# Run setup
${SCRIPT_DIR}/popos/setup-popos.sh

# Make sure we have some common folders
${SCRIPT_DIR}/common/create-folders.sh

# Install some global Node packages
${SCRIPT_DIR}/common/install-node.sh

# Install the remaining things from source
${SCRIPT_DIR}/common/install-git.sh
