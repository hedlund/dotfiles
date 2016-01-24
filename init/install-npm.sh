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

# Install the Node softwares we want using NPM
ninst typescript
ninst tsd
ninst yo
ninst bower
ninst nodemon
