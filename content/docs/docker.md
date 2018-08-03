---
title: Docker
draft: false
date:
lastmod:
description: Contains best practices and tips related to Docker and the 3 Musketeers.
weight: 200
toc: true
---

# Docker

This section contains some tips related to Docker.

## Useful Docker Images

### jwilder/dockerize

Often, there is a need to wait for a service before doing something else. For instance, waiting for a database container to be ready before running migration. The image `jwilder/dockerize` can be used.

```Makefile
dbStart:
	docker-compose up -d db
	docker-compose run --rm dockerize -wait tcp://db:3306 -timeout 60s
.PHONY: dbStart
```

## Image without make

One of the [patterns][] is to call Make from Compose. If you want to follow this pattern and your image does not have `make`, here are some solutions to address that.

### Use a different image

Often image publishers offer different versions of the application/product. For instance [golang][golang] has an image based on `alpine` which does not have `make`. It also has an image based on `stretch` which has `make`.

```bash
$ docker run --rm golang:alpine make
# "exec: \"make\": executable file not found
$ docker run --rm golang:stretch make
# make: *** No targets specified and no makefile found
```

### Use Musketeers Docker image

If you only want to call `make` with common shell commands, or want to use `git`, `zip`, or even `Cookiecutter`, then the lightweight [Musketeers Docker][dockerMusketeersRepo] image is for you.

### Install make on the fly

Whenever a command runs a command it installs `make` and then execute `$ make _target`. Depending on how many time a command is run, this way may be very inefficient as it needs to download `make` every single time.

```bash
$ docker run --rm golang:alpine apk add --update make && make _target
```

### Build your own image

You may want to build and maintain your own image based on the the image you wanted to use.

```Dockerfile
FROM golang:alpine
RUN apk add --update make
...
```

## Docker development is slow

It may happen that using Docker when mounting volumes is slow on Mac and Windows. For instance, developing a rails application. An handy tool to have is [docker-sync][dockerSync]

On Mac, I found using the strategy `native_osx` to work well.

The Docker Compose file would look like the following:

```yml
 yourservice:
    image: animage
    volumes:
      - app-sync:/opt/app:nocopy
...

volumes:
  # this volume is created by docker-sync. See docker-sync.yml for the config
  app-sync:
    external: true
```

This would work well on Windows/Mac but what about Linux? Either docker-sync is still used, which uses the native strategy and would not sync, or you use an environment variable which set the volume: `app-sync:/opt/app:nocopy` or `.:/opt/app`.


[dockerSync]: http://docker-sync.io
[musketeersLambdaGoServerless]: https://gitlab.com/flemay/cookiecutter-musketeers-lambda-go-serverless/
[golang]: https://hub.docker.com/_/golang/
[dockerMusketeersRepo]: https://github.com/flemay/docker-musketeers
[patterns]: ../patterns