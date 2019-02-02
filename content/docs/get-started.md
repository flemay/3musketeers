---
title: Get Started
draft: false
date:
lastmod:
description: Everything you need to know about creating your very first 'Hello World' example using the 3 Musketeers.
weight: 50
menu: "header"
---

# Get Started

## Prerequisites

These are the prerequisites for a project that follows the 3 Musketeers:

- [Docker][docker]
- [Compose][compose]
- Make

[docker]: https://docs.docker.com/engine/installation/
[compose]: https://docs.docker.com/compose/install/

## Hello World

Create the 2 following files in any empty directory:

```yml
# file: docker-compose.yml

version: '3.4'
services:
  alpine:
    image: alpine
```

```Makefile
# file: Makefile

# echo calls Compose to run the command "echo 'Hello World!'" in a Docker container
echo:
	docker-compose run --rm alpine echo 'Hello World!'
```

Then simply echo "Hello World!" with the following command:

```bash
$ make echo
```
