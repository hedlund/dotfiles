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
ninst tsd

# Node development
ninst nodemon
ninst express-generator
ninst strongloop

# Some general dev tools
ninst yo
ninst bower

# CLI tools
ninst commander
ninst inquirer
ninst vorpal
