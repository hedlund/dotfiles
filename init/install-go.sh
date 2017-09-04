#!/usr/bin/env bash

if [ -z "$(which go)" ]; then
    echo "Golang not available. Aborting!"
    exit 1
fi

go get -v github.com/ramya-rao-a/go-outline
