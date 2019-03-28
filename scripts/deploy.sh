#!/usr/bin/env sh
set -e
set -u

netlifyctl --yes -A "${NETLIFY_TOKEN}" deploy --site-id "${NETLIFY_SITE_ID}"
