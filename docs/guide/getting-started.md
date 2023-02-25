# Getting started

## Prerequisites

These are the prerequisites for a project that follows the 3 Musketeers:

- [Docker&#8599;][linkDocker]
- [Compose&#8599;][linkCompose]
- Make

## Hello, World!

Create the two following files in an empty directory:

```yaml
# file: docker-compose.yml
version: '3'
services:
  alpine:
    image: alpine
```

```makefile
# file: Makefile

# echo calls Compose to run the command "echo 'Hello, World!'" in a Docker container
echo:
	docker-compose run --rm alpine echo 'Hello, World!'
```

Then simply echo "Hello, World!" with the following command:

```bash
$ make echo
```

[linkDocker]: https://docs.docker.com/engine/installation/
[linkCompose]: https://docs.docker.com/compose/install/
