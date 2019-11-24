#!/usr/bin/env sh
set -e
set -u

yarn netlify deploy --dir=docs/.vuepress/dist --prod
