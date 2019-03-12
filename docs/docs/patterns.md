---
title: Patterns
draft: false
date: "2018-07-28"
lastmod: "2018-07-31"
description: Overview of the patterns that can be used with the 3 Musketeers.
weight: 75
toc: true
---

# Patterns

This section covers different patterns about executing tasks with the 3 Musketeers. All examples in this section works out of the box as long as Docker, Compose, and Make are installed.

## Make

Make calls Compose which then calls another Make target inside a Docker container. This pattern requires the Docker image to have Make installed. Solutions about what to do if your image does not contain Make can be found [here][docker].

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
	docker-compose run --rm alpine make _echo

_echo:
	echo 'Hello World!'
```

```bash
$ make echo
```

## Shell command

Make calls Compose which executes a shell/bash command inside a Docker container.

```yml
# docker-compose.yml
version: '3.4'
services:
  alpine:
    image: alpine
```

```Makefile
# Makefile
echo:
	docker-compose run --rm alpine sh -c 'echo Hello World!'
```

```bash
$ make echo
```

## Shell file

Make calls Compose which executes a shell/bash command inside a Docker container. Also, an example of a shell file that mimics Make can be found [here][other-tips].

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

## Languages

Languages like Python, JavaScript, Golang, Ruby, etc can be used as an alternative to shell/bash scripts. The following example uses JavaScript to echo hello world.

```js
// helloworld.js
console.log('Hello World');
```

```yml
# docker-compose.yml
version: '3.4'
services:
  node:
    image: node:alpine
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```Makefile
# Makefile
echo:
	docker-compose run --rm node node helloworld.js
```

```bash
$ make echo
```

## Task management tool

There are many languages and tools out there to make task implementation easy such as Gulp and Rake. Those tools can easily be integrated to the 3 Musketeers. The following is simply a NodeJS example which echos "Hello World" by invoking npm.

```json
// package.json

{
  "name": "helloworld",
  "description": "echos Hello World!",
  "scripts": {
    "echo": "echo \"Hello World!\""
  },
}
```

```yml
# docker-compose.yml
version: '3.4'
services:
  node:
    image: node:alpine
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```Makefile
# Makefile
echo:
	docker-compose run --rm node npm run echo
```

```bash
$ make echo
```

## Docker

Make calls directly Docker instead of Compose. All example above can replace Compose with Docker but using Compose makes it more manageable. However, there are situations where calling straight Docker is required. For example, if you were to generate a `.env` file from a container, then using Compose would fail if one service in `docker-compose.yml` needs a `.env` file.

```Makefile
echo:
	docker run --rm alpine echo Hello World
```

```bash
$ make echo
```
---

More patterns coming soon!

[docker]: ../docker
[other-tips]: ../other-tips
