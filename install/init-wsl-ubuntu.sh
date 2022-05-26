#!/bin/bash -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Install basic stuff
${SCRIPT_DIR}/ubuntu/install-apt.sh --no-docker

# Only run if the Go version in the distribution repositories are too old
#${SCRIPT_DIR}/ubuntu/install-go.sh

# Install snaps
${SCRIPT_DIR}/ubuntu/install-snap.sh

# Install NodeJS stuff
${SCRIPT_DIR}/common/install-node.sh

# Install Go stuff
${SCRIPT_DIR}/common/install-golang.sh

# Make sure we have some common folders
${SCRIPT_DIR}/common/create-folders.sh

# Install the remaining things from source
${SCRIPT_DIR}/common/install-git.sh
