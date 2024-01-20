# Getting started

<!-- Copy of README.md#getting-started -->

Let's print out `Hello, World!` in the terminal using the 3 Musketeers. The command `make echo` will be calling Docker to run the command `echo 'Hello, World!'` inside a container.

![getting-started](./assets/getting-started.mmd.svg)

## Prerequisites

- [Docker][linkDocker]
- [Compose][linkCompose]
- [Make](https://www.gnu.org/software/make/)

## Hello, World!

Create the following 2 files:

```yaml
# docker-compose.yml
version: '3.8'
services:
  alpine:
    image: alpine
```

```makefile
# Makefile
echo:
	docker compose run --rm alpine echo 'Hello, World!'
```

Then simply run:

```bash
make echo
```

[linkDocker]: https://docs.docker.com/engine/installation/
[linkCompose]: https://docs.docker.com/compose/install/
