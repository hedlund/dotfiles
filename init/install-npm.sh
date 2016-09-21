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
ninst nodemon
ninst express-generator
ninst strongloop
ninst adonis-cli

# Some general dev tools
ninst yo
ninst http-server
ninst browser-sync
ninst eslint

# Some Tern related packages
ninst tern
ninst tern-eslint
ninst tern-node-express
ninst tern-phaser

# Book stuff
ninst gitbook-cli
