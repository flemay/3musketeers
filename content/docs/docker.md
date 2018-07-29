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

## Image size

Usually bigger images for development has `make` out of the box. However, sometimes you may want to have smaller images because it is faster to download and start. For instance, node stretch is a lot bigger than node alpine.

```bash
$ docker images | grep node
# node 9-stretch     892MB
# node 9-alpine      68.4MB
```

The downside is that alpine does not provide `make`. The next section covers ways to handle this situation.

## Image without make

One of the [patterns][] is to call Make from Compose, and if you want to do it but found out that your image does not have it installed, here are some solutions to address that.

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

[golang]: https://hub.docker.com/_/golang/
[dockerMusketeersRepo]: https://github.com/flemay/docker-musketeers
[patterns]: ../patterns