#!/usr/bin/env sh

rm -f *.mdd.svg
find *.mmd -type f \
    | LC_ALL=C sort \
    | xargs -I {} sh -c \
        'printf "File: %s\n" {}; \
        /home/mermaidcli/node_modules/.bin/mmdc \
            --puppeteerConfigFile /puppeteer-config.json \
            --backgroundColor transparent \
            --theme neutral \
            -i {}'
printf "Copy *.svg to docs/guide/assets\n"
#rm -fr /docs/guide/assets/*.svg
#cp *.svg /opt/docs/guide/assets
