#!/usr/bin/env bash
set -e
set -u

rm -fr resources/_gen
hugo server -b ${HUGO_BASE_URL} --bind="0.0.0.0" -v