FROM alpine:3.8
LABEL maintainer "@flemay"

RUN apk --update add bash libc6-compat nodejs npm make && rm -rf /var/cache/apk/*

# install hugo
WORKDIR /opt/hugo
ENV HUGO_VERSION 0.44
ENV HUGO_BIN_NAME hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz
ENV HUGO_BIN_URL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BIN_NAME}
RUN wget -qO- "${HUGO_BIN_URL}" | tar xz
ENV PATH "/opt/hugo:${PATH}"

# install netlifyctl tool
WORKDIR /opt/netlifyctl
RUN wget -qO- 'https://cli.netlify.com/download/latest/linux' | tar xz
ENV PATH "/opt/netlifyctl:${PATH}"

# install postcss globally for hugo
RUN npm install -g postcss-cli

WORKDIR /opt/app
