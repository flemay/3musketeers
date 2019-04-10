#!/usr/bin/env sh
set -e
set -u

yarn netlifyctl deploy --site="${NETLIFY_SITE_ID}" --dir=docs/.vuepress/dist --prod
