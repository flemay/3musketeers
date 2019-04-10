#!/usr/bin/env sh
set -e
set -u

yarn vuepress dev --debug --host 0.0.0.0 docs
