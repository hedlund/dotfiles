#!/usr/bin/env bash

if [ -z "$(which umake)" ]; then
    echo "ubuntu-make not available. Aborting!"
    exit 1
fi

umake ide arduino
umake go
