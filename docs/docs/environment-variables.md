# Environment variables & .env file

Development following [the twelve-factor app][12factor] use the [environment variables to configure][12factorConfig] their application.

Often there are many environment variables and having them in a `.env` file becomes handy. Docker and Compose do use [environment variables file][dockerEnvfile] to pass the variables to the containers.

> Refer to [Targets .env and envfile][linkMakeTargetEnvfile] of section Make for ways to handle `.env` file.

## .env.template, and .env.example

`.env.template` contains names of all environment variables the application and pipeline use. No values are set here. `.env.template` is meant to serve as a template to `.env`. If there is no `.env` in the directory and `ENVFILE` is not specified, Make will create a `.env` file with `.env.template`.

`.env.example` defines values so that it can be used straight away with Make like `$ make envfile test ENVFILE=.env.example`. It also gives an example of values that are being used in the project.

> As this file should be committed to source control, never include sensitive values like passwords.

## CI and .env.template

Usually, the `.env` file will be created from the `.env.template` with `make envfile`. Given the environment variables have already been set in the CI tool, those will be passed to Docker and Compose.

## Day-to-day development

In a day-to-day development process, you could create a file named `.env.dev` with the config of your dev environment and copy the contents of it into `.env` so that you can manually deploy/delete/etc your app for testing. This allows you to not accidentally lose the values if the `.env` file is replaced.
There are few ways to copy the contents of your file to `.env`:

- manually
- make envfile ENVFILE=_yourfile_

## Tutorial

This tutorial shows how `.env` files work with Docker and Docker Compose.

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

```yml
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

```Makefile
# file: Makefile

COMPOSE_RUN_MUSKETEERS = docker-compose run --rm musketeers

# ENVFILE is .env.template by default but can be overwritten
ENVFILE ?= .env.template

# envfile creates or overwrites .env with $(ENVFILE)
envfile:
	cp -f $(ENVFILE) .env
.PHONY: envfile

# shell creates a shell environment inside a container.
shell:
	$(COMPOSE_RUN_MUSKETEERS) sh -l
.PHONY: shell

# cleanDocker remove all containers/network created by Compose
cleanDocker:
	docker-compose down --remove-orphans
.PHONY: cleanDocker

# clean cleans the current directory
clean: cleanDocker
	rm -f .env
.PHONY: clean
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

## AWS environment variables vs ~/.aws

In the [lambda example][musketeersLambdaGoServerless], `envvars.yml` contains the following optional environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, and `AWS_PROFILE`. Also, the `docker-compose.yml` mounts the volume `~/.aws`.

If you are using `~/.aws`, you do not need to set values as they won't be included in the Docker container. If there is a value for any of the environment variables, it will take precedence over `~/.aws` when using aws cli.

[12factor]: https://12factor.net
[12factorConfig]: https://12factor.net/config
[dockerEnvfile]: https://docs.docker.com/compose/env-file/
[envvars]: https://github.com/flemay/envvars/
[linkMakeTargetEnvfile]: make#targets-env-and-envfile
[musketeersLambdaGoServerless]: https://github.com/3musketeersio/cookiecutter-musketeers-lambda-go-serverless
