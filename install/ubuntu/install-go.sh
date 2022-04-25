#!/bin/bash -e

VERSION="1.18.1"
ARCH="amd64"

if [ ! -d /usr/local/go ]; then
  wget -qO- "https://dl.google.com/go/go${VERSION}.linux-${ARCH}.tar.gz" | sudo tar -C /usr/local -xvzf -
fi