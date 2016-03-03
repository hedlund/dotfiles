#!/usr/bin/env bash

# Install some good Atom plugins
apm install atom-typescript
apm install atom-material-ui atom-material-syntax
apm install dash
apm install language-docker
apm install language-jade
apm install language-ejs

# Install TernJS support
apm install atom-ternjs
(cd $HOME/.atom/packages/atom-ternjs && npm install tern-node-express)
