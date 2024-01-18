# Getting started

## Prerequisites

These are the prerequisites for a project that follows the 3 Musketeers:

- [Docker][linkDocker]
- [Compose][linkCompose]
- Make

## Hello, World!

Create the following two files:

```yaml
# docker-compose.yml
version: '3'
services:
  alpine:
    image: alpine
```

```makefile
# Makefile

echo:
	docker compose run --rm alpine echo 'Hello, World!'
```

Then simply echo "Hello, World!" with the following command:

```bash
$ make echo
```

[linkDocker]: https://docs.docker.com/engine/installation/
[linkCompose]: https://docs.docker.com/compose/install/
