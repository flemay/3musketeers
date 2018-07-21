---
title: Environment variables & envfile
draft: false
date:
lastmod:
description: Explains how environment variables and envfile work with Docker and Compose.
weight: 350
toc: true
---

# Environment variables & envfile

Development following [the twelve-factor app][12factor] use the [environment variables to configure][12factorConfig] their application.

Often there are many environment variables and having them in a `.env` file becomes handy. Docker and Compose do use [environment variables file][dockerEnvfile] to pass the variables to the containers.

## .env.template, and .env.example

`.env.template` contains names of all environment variables the application and pipeline use. No values are set here. `.env.template` is meant to serve as a template to `.env`. If there is no `.env` in the directory and `ENVFILE` is not specified, Make will create a `.env` file with `.env.template`.

`.env.example` defines values so that it can be used straight away with Make like `$ make envfile test ENVFILE=.env.example`. It also gives an example of values that is being used in the project.

> Never include sensitive values like passwords as this file is meant to be checked in.

> Those files could be replaced with the tool [envvars][].
> `envvars` is a flexible tool to describe and validate environment variables. The process is similar to using `.env.template` and `.env.example`.

## CI and .env.template

Usually, the `.env` file will be created from the `.env.template` with `make envfile`. Given the environment variables are already been set in the CI, those will be passed to Docker and Compose.

## Day to day development

In a day to day development process, you could create a file like `.env.dev` with the config of your dev environment and copy the content of it into `.env` so that you can manually deploy/delete/etc your app for testing. This allows you to not loose accidentally the values if `.env` was to get replaced or the need to set all the environment variables on your machine.

There are few ways to copy the content of your file to `.env`:

- manually
- make envfile ENVFILE=_yourfile_

## Tutorial

This Tutorial shows how `.env` file works with Docker and Docker Compose.

### Files

Create the following files

```bash
# file: .env.template
ECHO_MESSAGE
```

```bash
# file: .env.example
ECHO_MESSAGE="Hello 3 Musketeers"
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
# Oupps! Error. Compose needs a .env file. Let's create one
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
# What happened to .env file?
$ cat .env
$ env | grep ECHO_MESSAGE
# What's the value of ECHO_MESSAGE? Why isn't "Hello World"?
$ exit
# Clean the work directory
$ make clean

# The 2 previous steps can be combined into 1
$ make envfile shell ENVFILE=.env.example
$ exit

# Clean your current repository
$ make clean
```

[12factor]: https://12factor.net
[12factorConfig]: https://12factor.net/config
[dockerEnvfile]: https://docs.docker.com/compose/env-file/
[envvars]: https://github.com/flemay/envvars/