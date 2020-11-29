#!/usr/bin/env sh
set -e
set -u

npx netlify deploy --dir=docs/.vuepress/dist --prod
