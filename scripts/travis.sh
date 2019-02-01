#!/usr/bin/env bash
set -e
set -u

# During a pull request, encryoted parameters are not passed.
# https://docs.travis-ci.com/user/pull-requests/#pull-requests-and-security-restrictions
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  echo Triggered on Pull Request
  make onPullRequest
else
  echo Triggered on Merge to Master
  make onMergeToMaster
fi