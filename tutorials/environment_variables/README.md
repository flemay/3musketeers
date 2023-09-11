<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Tutorial: Environment variables](#tutorial-environment-variables)
  - [Envfile with Docker and Compose](#envfile-with-docker-and-compose)
    - [Files](#files)
    - [Steps](#steps)
  - [Overwriting .env or not](#overwriting-env-or-not)
  - [Create envfile with Make and Compose](#create-envfile-with-make-and-compose)
    - [Explicit](#explicit)
    - [Semi-Implicit](#semi-implicit)
    - [Implicit](#implicit)
  - [Create envfile with Make and Docker](#create-envfile-with-make-and-docker)
    - [Explicit](#explicit-1)
    - [Semi-Implicit](#semi-implicit-1)
    - [Implicit](#implicit-1)
  - [Environment variable check for Make target](#environment-variable-check-for-make-target)
  - [Access environment variables in command argument](#access-environment-variables-in-command-argument)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Tutorial: Environment variables

This tutorial shows how `.env` file works with Docker and Docker Compose.

> **INFO**
>
> More context about environment variables and 3 Musketeers can be found [here][linkEnvVarsContext].

## Envfile with Docker and Compose

### Files

Create the following files:

```bash
# file: env.template
ECHO_MESSAGE
```

```bash
# file: env.example
ECHO_MESSAGE="Hello, 3 Musketeers!"
```

```yaml
# file: docker-compose.yml
version: '3'
services:
  musketeers:
    image: flemay/musketeers
    env_file: .env
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```make
# file: makefile
COMPOSE_RUN_MUSKETEERS = docker-compose run --rm musketeers

# ENVFILE is env.template by default but can be overwritten
ENVFILE ?= env.template

# envfile creates or overwrites .env with $(ENVFILE)
envfile:
	cp -f $(ENVFILE) .env

# shell creates a shell environment inside a container.
shell:
	$(COMPOSE_RUN_MUSKETEERS) sh -l

# cleanDocker remove all containers/network created by Compose
cleanDocker:
	docker-compose down --remove-orphans

# clean cleans the current directory
clean: cleanDocker
	rm -f .env
```

### Steps

```bash
# Let's clean first
$ make clean

# Let's go inside a container.
$ make shell
# Opps! Error. Compose needs a .env file. Let's create one...
$ make envfile
$ make shell
# See the new .env file?
$ ls -la
$ cat .env
# Let's look at the environment variable ECHO_MESSAGE
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
$ export ECHO_MESSAGE="Hello, World!"
$ make shell
# Any change to .env?
$ cat .env
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
# Create a .env file based on the env.example
$ make envfile ENVFILE=env.example
$ make shell
# What happened to our .env file?
$ cat .env
$ env | grep ECHO_MESSAGE
# What's the value of ECHO_MESSAGE? Why isn't it "Hello, World!"?
$ exit
# Clean the work directory
$ make clean

# The two previous steps can be combined into one
$ make envfile shell ENVFILE=env.example
$ exit

# Clean your current repository
$ make clean
```

## Overwriting .env or not

Examples in this page use `.env` to pass environment variables to a container. The file `.env` can be overwritten when setting the environment variable `ENVFILE`. This has few advantages:

- You know the file `.env` will always be used
- Compose uses `.env` when doing [variable substitution][linkDockerComposeVarialeSubstitution]

## Create envfile with Make and Compose

This section shows some ways to create `.env` file with Make and Compose with the given `docker-compose.yml` file:

```yaml
# docker-compose.yml
version: "3.7"
services:
  alpine:
    image: alpine
    env_file: ${ENVFILE:-.env}
    volumes:
      - type: bind
        source: "."
        target: /opt/app
    working_dir: /opt/app
```

The `docker-compose.yml` above has the [variable substitution][linkDockerComposeVarialeSubstitution] `env_file: ${ENVFILE:-.env}`, which allows the use of a different file that `.env` by defining the environment variable `ENVFILE`. This was required for using Compose otherwise Compose would simply fail. Examples in this section will use `.env` except when generating the file.

### Explicit

Targets requiring `.env` file will fail if the file does not exist. The `.env` file can be created with `envfile` target.

> **INFO**
>
> Explicit is the method I personally prefer.

```make
# Makefile
COMPOSE_RUN_ALPINE = docker-compose run alpine
ENVFILE ?= env.template

envfile:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) cp $(ENVFILE) .env

targetA: .env
	$(COMPOSE_RUN_ALPINE) cat .env

targetB:
    $(COMPOSE_RUN_ALPINE) echo "Hello, World!"

# clean removes the .env
clean: .env
	$(COMPOSE_RUN_ALPINE) rm .env
```

```bash
# fail if .env does not exist
$ make targetA
# fail if .env does not exist even if targetB does not require .env because Compose does in our case
$ make targetB
# overwrite .env based on env.template
$ make envfile
# overwrite .env with a specific file
$ make envfile ENVFILE=env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=env.example
```

### Semi-Implicit

Targets requiring `.env` file will get it created if it does not exist. The `.env` file can be overwritten by calling `make envfile ENVFILE=.env.example`.

```make
# Makefile
COMPOSE_RUN_ALPINE = docker-compose run alpine
ENVFILE ?= env.template

# .env creates .env based on $(ENVFILE) if .env does not exist
.env:
	$(MAKE) envfile

# envfile overwrites .env with $(ENVFILE)
envfile:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) cp $(ENVFILE) .env

# target requires .env
target: .env
	$(COMPOSE_RUN_ALPINE) cat .env

# clean removes the .env
clean: .env
	$(COMPOSE_RUN_ALPINE) rm .env
```

```bash
# create, if it does not exist, .env based on env.template
$ make target
# create .env, if it does not exist, based on env.template
$ make .env
# create .env, if it does not exist, based on $(ENVFILE)
$ make .env ENVFILE=env.example
# overwrite .env based on env.template
$ make envfile
# overwrite .env with a specific file
$ make envfile ENVFILE=env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=env.example
```

### Implicit

Targets requiring `.env` file will get it created if it does not exist. The `.env` file can be overwritten by setting `ENVFILE` environment variable.

```makefile
# Makefile
COMPOSE_RUN_ALPINE = docker-compose run alpine
ifdef ENVFILE
	ENVFILE_TARGET=envfile
else
	ENVFILE_TARGET=.env
endif

# Create .env based on env.template if .env does not exist
.env:
	$(MAKE) envfile ENVFILE=env.template

# Create/Overwrite .env with $(ENVFILE)
envfile:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) cp $(ENVFILE) .env

# target requiring $(ENVFILE_TARGET)
target: $(ENVFILE_TARGET)
	$(COMPOSE_RUN_ALPINE) cat .env

# clean removes the .env
clean: $(ENVFILE_TARGET)
  $(COMPOSE_RUN_ALPINE) rm .env
```

```bash
# create .env, if it does not exist, based on env.template
$ make target
# create .env, if it does not exist, based on env.template
$ make .env
# create .env, if it does not exist, a specific file
$ make .env ENVFILE=env.example
# overwrite .env with a specific file
$ make envfile ENVFILE=env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=env.example
# or (no need to specify envfile)
$ make target ENVFILE=env.example
```

## Create envfile with Make and Docker

This section shows some ways to create `.env` file with Make and Docker.

> **INFO**
>
> Examples below use Alpine container ([Docker pattern][linkPatternsDocker]) to create `.env` file. However, in most cases, using the host `cp` (and `rm`) is fine.

### Explicit

Targets requiring `.env` file will fail if the file does not exist. The `.env` file can be created with `envfile` target.

```makefile
# Makefile
MAKEFILE_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
DOCKER_RUN_ALPINE = docker run --rm -v $(MAKEFILE_DIR):/opt/app -w /opt/app alpine
ENVFILE ?= env.template

# envfile overwrites .env with $(ENVFILE)
envfile:
	$(DOCKER_RUN_ALPINE) cp $(ENVFILE) .env

# target requires .env
target: .env
	$(DOCKER_RUN_ALPINE) cat .env

# clean removes the .env
clean:
  $(DOCKER_RUN_ALPINE) rm .env
```

```bash
# fail if .env does not exist
$ make target
# overwrite .env based on env.template
$ make envfile
# overwrite .env with a specific file
$ make envfile ENVFILE=env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=env.example
```

### Semi-Implicit

Targets requiring `.env` file will get it created if it does not exist. The `.env` file can be overwritten by calling `make envfile ENVFILE=.env.example`.

```makefile
# Makefile
MAKEFILE_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
DOCKER_RUN_ALPINE = docker run --rm -v $(MAKEFILE_DIR):/opt/app -w /opt/app alpine
ENVFILE ?= env.template

# .env creates .env based on $(ENVFILE) if .env does not exist
.env:
	$(MAKE) envfile

# envfile overwrites .env with $(ENVFILE)
envfile:
	$(DOCKER_RUN_ALPINE) cp $(ENVFILE) .env

# target requires .env
target: .env
	$(DOCKER_RUN_ALPINE) cat .env

# clean removes the .env
clean:
  $(DOCKER_RUN_ALPINE) rm .env
```

```bash
# create, if it does not exist, .env based on env.template
$ make target
# create .env, if it does not exist, based on env.template
$ make .env
# create .env, if it does not exist, based on $(ENVFILE)
$ make .env ENVFILE=env.example
# overwrite .env based on env.template
$ make envfile
# overwrite .env with a specific file
$ make envfile ENVFILE=env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=env.example
```

### Implicit

Targets requiring `.env` file will get it created if it does not exist. The `.env` file can be overwritten by setting `ENVFILE` environment variable.

```makefile
# Makefile
MAKEFILE_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
DOCKER_RUN_ALPINE = docker run --rm -v $(MAKEFILE_DIR):/opt/app -w /opt/app alpine
ifdef ENVFILE
	ENVFILE_TARGET=envfile
else
	ENVFILE_TARGET=.env
endif

# Create .env based on env.template if .env does not exist
.env:
	$(MAKE) envfile ENVFILE=env.template

# Create/Overwrite .env with $(ENVFILE)
envfile:
	$(DOCKER_RUN_ALPINE) cp $(ENVFILE) .env

# target requiring $(ENVFILE_TARGET)
target: $(ENVFILE_TARGET)
	$(DOCKER_RUN_ALPINE) cat .env

# clean removes the .env
clean:
  $(DOCKER_RUN_ALPINE) rm .env
```

```bash
# create .env, if it does not exist, based on env.template
$ make target
# create .env, if it does not exist, based on env.template
$ make .env
# create .env, if it does not exist, a specific file
$ make .env ENVFILE=env.example
# overwrite .env with a specific file
$ make envfile ENVFILE=env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=env.example
# or (no need to specify envfile)
$ make target ENVFILE=env.example
```

## Environment variable check for Make target

Here is a way of checking the presence of environment variables before executing a Make target.

```makefile
echo: env-MESSAGE
	@docker run --rm alpine echo "$(MESSAGE)"

env-%:
	@docker run --rm -e ENV_VAR=$($*) alpine echo "Check if $* is not empty"
	@docker run --rm -e ENV_VAR=$($*) alpine sh -c '[ -z "$$ENV_VAR" ] && echo "Error: $* is empty" && exit 1 || exit 0'
```

```bash
# Call echo without a MESSAGE
$ make echo
Check if MESSAGE is not empty
Error: MESSAGE is empty
make: *** [env-MESSAGE] Error 1

# Call echo with a MESSAGE
$ make echo MESSAGE=helloworld
Check if MESSAGE is not empty
helloworld
```

## Access environment variables in command argument

```bash
# writing something like the following
$ docker run --rm -e ECHO=musketeers alpine sh -c "echo $ECHO"
# will simply echo nothing even if ECHO is being passed.

# To access ECHO, either use '\'
$ docker run --rm -e ECHO=musketeers alpine sh -c "echo \$ECHO"

# or use single quote
$ docker run --rm -e ECHO=musketeers alpine sh -c 'echo $ECHO'

# Same applies to Compose.
```

[linkPatternsDocker]: https://3musketeersdev.netlify.app/guide/patterns.html#docker

[linkDockerComposeVarialeSubstitution]: https://docs.docker.com/compose/compose-file/#variable-substitution
[linkEnvVarsContext]: https://3musketeersdev.netlify.app/guide/environment-variables.html
