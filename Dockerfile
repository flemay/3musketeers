# TODO: Try to make it work with alpine
# libstdc++ is needed for npm:sharp
# FROM denoland/deno:alpine
# RUN apk --no-cache update \
#     && apk --no-cache upgrade \
#     && apk --no-cache add --upgrade make bash libstdc++ vips-dev build-base
    # && apk --no-cache add --upgrade make bash libstdc++ vips-dev build-base

# node is currently chosen because astro build somehow calls `npx`. If `npx` is not present, pagefind search pages are not generated
# It is also faster to install `deno` with `npm` than installing `nodejs` and `npm` from `denoland/deno:debian`
# FROM node:slim
# RUN apt update \
#   && apt install -y make git curl \
#   && apt clean
# RUN npm install -g deno \
#   && deno --version
# The following is required for Starlight `Last updated` timestamp to sucessfully access `.git` on Linux.
# It seems Starlight just silently fails if any error occurs and keeps the build running.
# As an example, running command `git rev-parse --is-shallow-repository` within a container on Linux results with error `fatal: detected dubious ownership in repository at '/opt/app'`
# RUN git config --global --add safe.directory /opt/app
# WORKDIR /opt/app

# Prior `@astrojs/starlight` verison `[0.37.4](https://github.com/withastro/starlight/blob/main/packages/starlight/CHANGELOG.md)`, NodeJS was used as base image because `astro build` would call `npx`. If `npx` wasn't present, `pagefind` page would not get generated.
FROM denoland/deno:debian
RUN apt update \
  && apt install -y git curl \
  && apt clean
# The following is required for Starlight `Last updated` timestamp to sucessfully access `.git` on Linux.
# It seems Starlight just silently fails if any error occurs and keeps the build running.
# As an example, running command `git rev-parse --is-shallow-repository` within a container on Linux results with error `fatal: detected dubious ownership in repository at '/opt/app'`
RUN git config --global --add safe.directory /opt/app
WORKDIR /opt/app
