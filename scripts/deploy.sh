#!/usr/bin/env sh
set -e
set -u

yarn netlify deploy --site="${NETLIFY_SITE_ID}" --dir=docs/.vuepress/dist --prod
