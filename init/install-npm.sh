#!/usr/bin/env bash

if [[ "$(uname -s)" == "Linux" ]]; then
    function ninst {
        sudo npm install -g $1
    }
else
    function ninst {
        npm install -g $1
    }
fi

# Typescript stuff
ninst typescript
ninst typings

# Node development
ninst yo
ninst nodemon
ninst http-server

#ninst hpm-cli
