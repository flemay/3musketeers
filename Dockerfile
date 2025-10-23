# TODO: Try to make it work with alpine
# libstdc++ is needed for npm:sharp
# FROM denoland/deno:alpine
# RUN apk --no-cache update \
#     && apk --no-cache upgrade \
#     && apk --no-cache add --upgrade make bash libstdc++ vips-dev build-base
    # && apk --no-cache add --upgrade make bash libstdc++ vips-dev build-base

# FROM denoland/deno:debian
# RUN apt update \
#   && apt install -y make nodejs npm \
#   && apt clean

# node is currently chosen because astro build somehow calls `npx`. If `npx is not present, pagefind search pages are not generated
# It is also faster to install `deno` with `npm` than installing `nodejs` and `npm` from `denoland/deno:debian`
FROM node:slim
RUN apt update \
  && apt install -y make git \
  && apt clean
RUN npm install -g deno \
  && deno --version
WORKDIR /opt/app
