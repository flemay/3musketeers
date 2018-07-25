---
title: Get Started
draft: false
date:
lastmod:
description: Everything you need to know about creating your very first `Hello World` using the 3 Musketeers
weight: 50
menu: "header"
---

# Getting Started

## Overview

{{< figure src="/img/overview.jpg" alt="overview" width="400" >}}

A host, be it Mac, Linux, Windows, CI, etc, calls a Make target which delegates the execution of a command inside a Docker container to Compose.

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

# compose defines services to be used in Make
version: '3.4'
services:
  musketeers:
    image: flemay/musketeers
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```Makefile
# file: Makefile

# echo calls Compose to run _echo within a Docker container
echo:
	docker-compose run musketeers make _echo
.PHONY: echo

# _echo will be executed inside a Docker container
_echo:
	echo "Hello World!"
.PHONY: _echo
```

Then simply echo "Hello World!" with the following command:

```bash
$ make echo
```
