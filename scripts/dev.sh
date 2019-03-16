#!/usr/bin/env sh
set -e
set -u

npx vuepress dev --debug --host 0.0.0.0 docs
