#!/usr/bin/env sh
set -e
set -u

testcafe "${TESTCAFE_BROWSER}" test/*.ts
