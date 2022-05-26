#!/bin/bash -e

# Only use this script if the distribution repositories does not contain a
# version that is updated enough.

VERSION="1.18.2"
ARCH="amd64"

if [ ! -d /usr/local/go ]; then
  wget -qO- "https://dl.google.com/go/go${VERSION}.linux-${ARCH}.tar.gz" | sudo tar -C /usr/local -xvzf -
fi
