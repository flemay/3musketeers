#!/usr/bin/env bash
set -e
set -u

rm -fr resources/_gen public
hugo -b ${HUGO_BASE_URL}