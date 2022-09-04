# Environment variables

Development following [the twelve-factor app][link12factor] use the [environment variables to configure][link12factorConfig] their application.

Often there are many environment variables and having them in a `.env` file becomes handy. Docker and Compose do use [environment variables file][linkDockerEnvfile] to pass the variables to the containers.

## .env file and expectations

With the following `.env` file:

```
# make sure these env vars are not set in the system
ENV_A
ENV_B=
ENV_C=env_c
```

And the `docker-compose.yml` file:

```yaml
services:
  alpine:
    image: alpine
    env_file: .env
```

The expected results are:

```bash
$ docker run --rm --env-file=.env alpine env
ENV_B=
ENV_C=env_c
# ENV_A is not set and ENV_B is set to empty

$ docker-compose run --rm alpine env
ENV_B=
ENV_C=env_c
# Same as Docker
```

## Structuring .env file

Environment variables can be used at different stages of software development: build, test, deploy, and run time. The following is an example how to keep .env file structured.

```
# All
ENV

# Deploy
AWS_VPC

# Test
CODECOV_URL

# Build and deploy
BUILD_DIR

# Test and run
DB_HOST
```

## env.template and env.example

`env.template` and `env.example` files provide some help when managing environment variables in a project.

::: danger ENV FILES AND SOURCE CONTROL
As `env.template` and `env.example` files are meant to be part of the source code, never include sensitive values like passwords. Additionally, include `.env*` in your `.gitignore`.
:::

### env.template

`env.template` contains names (key-only) of all environment variables the application and pipeline use. No values are set here. `# description` can be used to describe an environment variable. `env.template` is mainly used as a template to `.env` in a [CI/CD pipeline][linkCICDAndEnvFile].

```bash
# env.template
ENV_VAR_A
ENV_VAR_B
```

### env.example

`env.example` defines values so that it can be used straight away with Make like `$ make envfile test ENVFILE=env.example`. It also gives an example of values that are being used in the project which is very useful for the developers.

```bash
# env.example
ENV_VAR_A=a
ENV_VAR_B=b
```

### Pros

- Simple
  - Understanding the concept is pretty straight forward
  - Does not require any script
- Application agnostic
   - This pattern can be used for any environment variable of any kind of application
- Descriptive and explicit
  - `env.template` tells what environment variables are used by the project
  - `env.example` shows what value those environment variables can have
  - Environment variables needs to explicitly be added
- Flexible
  - The way the environment variables are set is up to you. They can be included in the `.env` file when developing locally or exported in a CD/CI host

### Cons

- Environment variable management is not centralized
  - Adding, modifying, or deleting environment variables may impact multiple files such as
    - env.template
    - env.example
    - makefile
    - docker-compose.yml
    - application source code
    - pipeline-as-code file
- Error prone
  - It is easy to forget to add a new environment variable to the `env.template/env.example` files

## CI/CD pipeline

Given all environment variables are set in your CI/CD pipeline, creating a `.env` file based on `env.template` allows values of those environment variables to be passed to the Docker container environments. See this [tutorial][linkUnderstandingEnvFile] to better understand the use of `.env` file with Docker and Compose.

## Day-to-day development

In a day-to-day development process, you could create a file named `.env.dev` with the config of your dev environment and copy the contents of it into `.env` so that you can manually deploy/delete/etc your app for testing. This allows you to not accidentally lose the values if the `.env` file is replaced.
There are few ways to copy the contents of your file to `.env`:

- manually
- [make envfile ENVFILE=_yourfile_][linkMakeTargetsEnvfileAndDotEnv]

## Understanding .env file with Docker and Compose

This tutorial shows how `.env` file works with Docker and Docker Compose.

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

```makefile
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

## Create .env file with Make and Compose

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

::: info
Explicit is the method I personally prefer.
:::

```makefile
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

```makefile
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

## Create .env file with Make and Docker

This section shows some ways to create `.env` file with Make and Docker.

::: info
Examples below use Alpine container ([Docker pattern][linkPatternsDocker]) to create `.env` file. However, in most cases, using the host `cp` (and `rm`) is fine.
:::

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

[linkMakeTargetsEnvfileAndDotEnv]: #make-targets-envfile-and-env
[linkCICDAndEnvFile]: #ci-cd-pipeline
[linkUnderstandingEnvFile]: #understanding-env-file-with-docker-and-compose
[linkPatternsDocker]: patterns.html#docker
[linkImplicitWithoutAlteringEnv]: ###implicit-without-altering-env

[link12factor]: https://12factor.net
[link12factorConfig]: https://12factor.net/config
[linkDockerEnvfile]: https://docs.docker.com/compose/env-file/
[linkAssumeRole]: https://github.com/remind101/assume-role
[linkDockerComposeVarialeSubstitution]: https://docs.docker.com/compose/compose-file/#variable-substitution
