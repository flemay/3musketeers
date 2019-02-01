#!/usr/bin/env sh
set -e
set -u

# deploy only to netlify if TRAVIS_BRANCH is master and that is it not coming from a pull request
if [ "${TRAVIS_BRANCH}" = "master" -a "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  netlifyctl --yes -A ${NETLIFY_TOKEN} deploy --site-id ${NETLIFY_SITE_ID}
  echo " DEPLOYED!"
else
  echo " SKIPPED deployment"
fi