#!/usr/bin/env sh

rm -f *.mdd.svg
find *.mmd -type f \
    | LC_ALL=C sort \
    | xargs -I {} sh -c \
        'printf "File: %s\n" {}; \
        /home/mermaidcli/node_modules/.bin/mmdc \
            -p /puppeteer-config.json \
            -b transparent \
            -i {}'
printf "Copy *.svg to docs/guide/assets"
rm -fr /docs/guide/assets/*.svg
cp *.svg /opt/docs/guide/assets
