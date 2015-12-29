#!/usr/bin/env bash

if [ -z "$(which apt-get)" ]; then
    echo "apt-get not available. Aborting!"
    exit 1
fi


