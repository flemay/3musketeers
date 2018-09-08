#!/usr/bin/env bash

# generates the code highlighting.
# Only use it if needing an updated since the source file is already checked in.
# more themes here # https://xyproto.github.io/splash/docs/all.html

set -e
set -u

CHROMA_STYLE=monokai
hugo gen chromastyles --style=${CHROMA_STYLE} > assets/css/chroma.css