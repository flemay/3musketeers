#!/usr/bin/env sh
set -e
set -u

# deploy only to netlify if TRAVIS_BRANCH is master
if [ "${TRAVIS_BRANCH}" = "master" ]; then
  netlifyctl --yes -A ${NETLIFY_TOKEN} deploy --site-id ${NETLIFY_SITE_ID}
  echo " DEPLOYED!"
else
  echo " SKIPPED deployment"
fi