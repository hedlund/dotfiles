#!/bin/bash -e

GOLANGCI_LINT_VERSION="1.46.2"

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
  go install "github.com/golangci/golangci-lint/cmd/golangci-lint@v${GOLANGCI_LINT_VERSION}"
fi

if ! exists task; then
  echo "Installing taskfile..."
  go install github.com/go-task/task/v3/cmd/task@latest
fi
