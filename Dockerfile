# TODO: Try to make it work with alpine
# libstdc++ is needed for npm:sharp
# FROM denoland/deno:alpine
# RUN apk --no-cache update \
#     && apk --no-cache upgrade \
#     && apk --no-cache add --upgrade make bash libstdc++

FROM denoland/deno:debian
RUN apt update \
  && apt install -y make \
  && apt clean
WORKDIR /opt/app
