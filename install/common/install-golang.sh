#!/bin/bash -e

if [ -z "$(which go)" ]; then
  echo "Golang not available. Skipping!"
  exit 0
fi

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${SCRIPT_DIR}/helpers.sh"

# Set the GOPATH and make sure the folder exists
export GOPATH="$HOME/Projects/golang"
[ ! -d "$GOPATH/src" ] && mkdir -p "$GOPATH/src"

if ! exists golangci-lint; then
  echo "Installing golangci-lint..."
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0
fi
