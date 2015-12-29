#!/usr/bin/env bash

if [ -z "$(which yum)" ]; then
    echo "yum not available. Aborting!"
    exit 1
fi
