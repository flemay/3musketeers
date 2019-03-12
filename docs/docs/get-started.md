# Get Started

## Prerequisites

These are the prerequisites for a project that follows the 3 Musketeers:

- [Docker][docker]
- [Compose][compose]
- Make

## Hello World

Create the two following files in an empty directory:

```yml
# file: docker-compose.yml

version: '3.4'
services:
  alpine:
    image: alpine
```

```Makefile
# file: Makefile

# echo calls Compose to run the command "echo 'Hello, World!'" in a Docker container
echo:
	docker-compose run --rm alpine echo 'Hello, World!'
```

Then simply echo "Hello, World!" with the following command:

```bash
$ make echo
```

[docker]: https://docs.docker.com/engine/installation/
[compose]: https://docs.docker.com/compose/install/