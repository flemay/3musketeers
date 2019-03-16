# Environment variables and .env file

Development following [the twelve-factor app][link12factor] use the [environment variables to configure][link12factorConfig] their application.

Often there are many environment variables and having them in a `.env` file becomes handy. Docker and Compose do use [environment variables file][linkDockerEnvfile] to pass the variables to the containers.

## .env.template and .env.example

`.env.template` contains names of all environment variables the application and pipeline use. No values are set here. `.env.template` is meant to serve as a template to `.env`. If there is no `.env` in the directory and `ENVFILE` is not specified, Make will create a `.env` file with `.env.template`.

`.env.example` defines values so that it can be used straight away with Make like `$ make envfile test ENVFILE=.env.example`. It also gives an example of values that are being used in the project.

::: warning
Never include sensitive values like passwords inside `.env.template` and `.env.examples` as they are meant to be committed to a source control.
:::

## CI and .env.template

Usually, the `.env` file will be created from the `.env.template` with `make envfile`. Given the environment variables have already been set in the CI tool, those will be passed to Docker and Compose.

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
# file: .env.template
ECHO_MESSAGE
```

```bash
# file: .env.example
ECHO_MESSAGE="Hello, 3 Musketeers!"
```

```yaml
# file: docker-compose.yml
version: '3.4'
services:
  musketeers:
    image: flemay/musketeers
    env_file: .env
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```makefile
# file: Makefile
COMPOSE_RUN_MUSKETEERS = docker-compose run --rm musketeers

# ENVFILE is .env.template by default but can be overwritten
ENVFILE ?= .env.template

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
$ export ECHO_MESSAGE="Hello World"
$ make shell
# Any change to .env?
$ cat .env
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
# Create a .env file based on the .env.example
$ make envfile ENVFILE=.env.example
$ make shell
# What happened to our .env file?
$ cat .env
$ env | grep ECHO_MESSAGE
# What's the value of ECHO_MESSAGE? Why isn't it "Hello World"?
$ exit
# Clean the work directory
$ make clean

# The two previous steps can be combined into one
$ make envfile shell ENVFILE=.env.example
$ exit

# Clean your current repository
$ make clean
```

## Make targets envfile and .env

The target `envfile` creates the file `.env` and there are different ways to implement it.

### Explicit

This way requires to call envfile to create the file `.env`.

```makefile
DOCKER_RUN_ALPINE = docker run --rm -v $(PWD):/opt/app -w /opt/app alpine
ENVFILE ?= .env.template

# envfile creates/overwrites .env with $(ENVFILE)
envfile:
	$(DOCKER_RUN_ALPINE) cp $(ENVFILE) .env

# target requiring .env
target: .env
```

```bash
# fails if .env does not exist
$ make target
# create .env based on .env.template
$ make envfile
# create .env with a specific file
$ make envfile ENVFILE=.env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=.env.example
```

### Semi-Implicit

```makefile
DOCKER_RUN_ALPINE = docker run --rm -v $(PWD):/opt/app -w /opt/app alpine
ENVFILE ?= .env.template

# Create .env based on .env.template if .env does not exist
.env:
	$(DOCKER_RUN_ALPINE) cp .env.template .env

# Create/Overwrite .env with $(ENVFILE)
envfile:
	$(DOCKER_RUN_ALPINE) cp $(ENVFILE) .env

# target requiring .env
target: .env
```

```bash
# create .env based on .env.template if it does not exist
$ make target
# create .env based on .env.template
$ make envfile
# create .env with a specific file
$ make envfile ENVFILE=.env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=.env.example
```

### Implicit

```makefile
DOCKER_RUN_ALPINE = docker run --rm -v $(PWD):/opt/app -w /opt/app alpine
ifdef ENVFILE
	ENVFILE_TARGET=envfile
else
	ENVFILE_TARGET=.env
endif

# Create .env based on .env.template if .env does not exist
.env:
	$(DOCKER_RUN_ALPINE) cp .env.template .env

# Create/Overwrite .env with $(ENVFILE)
envfile:
	$(DOCKER_RUN_ALPINE) cp $(ENVFILE) .env

# target requiring $(ENVFILE_TARGET)
target: $(ENVFILE_TARGET)
```

```bash
# create .env based on .env.template if it does not exist
$ make target
# create .env (if it does not exist) based on .env.template
$ make .env
# create/overwrite .env with a specific file
$ make envfile ENVFILE=.env.example
# execute a target with a specific .env file
$ make envfile target ENVFILE=.env.example
# or (no need to specify envfile)
$ make target ENVFILE=.env.example
```

## AWS environment variables vs ~/.aws

In the [lambda example][linkMusketeersLambdaGoServerless], `envvars.yml` contains the following optional environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, and `AWS_PROFILE`. Also, the `docker-compose.yml` mounts the volume `~/.aws`.

If you are using `~/.aws`, you do not need to set values as they won't be included in the Docker container. If there is a value for any of the environment variables, it will take precedence over `~/.aws` when using aws cli.


[linkMakeTargetsEnvfileAndDotEnv]: #make-targets-envfile-and-env

[linkMusketeersLambdaGoServerless]: https://github.com/3musketeersio/cookiecutter-musketeers-lambda-go-serverless
[link12factor]: https://12factor.net
[link12factorConfig]: https://12factor.net/config
[linkDockerEnvfile]: https://docs.docker.com/compose/env-file/
