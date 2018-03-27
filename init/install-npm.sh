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

ninst typescript
ninst yo
ninst serve
ninst depcheck
