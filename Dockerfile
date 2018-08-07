FROM golang
LABEL maintainer "@flemay"

# install hugo
WORKDIR /opt/hugo
ENV HUGO_VERSION 0.46
ENV HUGO_BIN_NAME hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz
ENV HUGO_BIN_URL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BIN_NAME}
RUN wget -qO- "${HUGO_BIN_URL}" | tar xz
ENV PATH "/opt/hugo:${PATH}"
RUN hugo version

# install node and few modules needed by Hugo
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g postcss-cli
RUN node --version

# install netlifyctl tool
WORKDIR /opt/netlifyctl
RUN wget -qO- 'https://cli.netlify.com/download/latest/linux' | tar xz
ENV PATH "/opt/netlifyctl:${PATH}"
RUN netlifyctl version

WORKDIR /opt/app
