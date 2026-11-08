FROM node:24
RUN apt update \
  && apt clean
RUN npm install -g pnpm@12
# The following is required for Starlight `Last updated` timestamp to sucessfully access `.git` on Linux.
# It seems Starlight just silently fails if any error occurs and keeps the build running.
# As an example, running command `git rev-parse --is-shallow-repository` within a container on Linux results with error `fatal: detected dubious ownership in repository at '/opt/app'`
RUN git config --global --add safe.directory /workspace
WORKDIR /workspace
