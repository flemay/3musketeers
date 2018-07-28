---
title: Patterns
draft: false
date: "2018-07-28"
lastmod:
description: Overview of the patterns that can be used with the 3 Musketeers.
weight: 75
toc: true
---

# Patterns

There are different patterns that can be applied with the 3 Musketeers.

## Make - Compose - Docker - Make

This pattern is the original one of the 3 Musketeers. In this pattern Make calls Compose which then calls another Make target inside a Docker container. This pattern requires the Docker image to have Make installed. Solutions about what to do if the image does not contain Make can be found [here][docker].

```yml
# docker-compose.yml
version: '3.4'
services:
  alpine:
    image: golang
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```Makefile
# Makefile
echo:
	docker-compose run alpine make _echo

_echo:
	echo 'Hello World!'
```

```bash
$ make echo
```

## Make - Compose - Docker - Shell command

In this pattern Make calls Compose which executes a shell/bash command inside a Docker container.

```yml
# docker-compose.yml
version: '3.4'
services:
  alpine:
    image: alpine
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```Makefile
# Makefile
echo:
	docker-compose run --rm alpine sh -c 'echo Hello World!'
```

```bash
$ make echo
```

## Make - Compose - Docker - Shell file

In this pattern Make calls Compose which executes a shell/bash command inside a Docker container.

```bash
# echo.sh
#!/usr/bin/env sh
echo Hello World!
```

```bash
# set executable permission
$ chmod +x echo.sh
```

```yml
# docker-compose.yml
version: '3.4'
services:
  alpine:
    image: alpine
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```Makefile
# Makefile
echo:
	docker-compose run --rm alpine sh echo.sh
```

```bash
$ make echo
```

---

More patterns coming soon!

[docker]: ../docker
