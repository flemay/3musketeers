#!/usr/bin/env sh

rm -f *.mdd.svg
find *.mmd -type f \
    | LC_ALL=C sort \
    | xargs -I {} sh -c \
        'printf "File: %s\n" {}; \
        /home/mermaidcli/node_modules/.bin/mmdc \
            -p /puppeteer-config.json \
            -t dark \
            -i {}'
