---
title: Make
draft: false
date:
lastmod:
description: Contains convention, best practices and tips related to Make and the 3 Musketeers.
weight: 100
toc: true
---

# Make

Having a clean Makefile is key. It helps to understand it quickly and to maintain. Therefore, having some conventions like [target vs _target](#target-vs-_target), [Pipeline targets](#pipeline-targets), and [Pipeline targets](#pipeline-targets) really aim to make developers' life easier.

> Most of the code snippets are taken from the [Lambda Go Serverless][musketeersLambdaGoServerless] example.

## target vs _target

Using `target` and `_target` is a naming convention to distinguish targets that can be called on any platform (Windows, Linux, MacOS) versus those that need specific environment/dependencies.

```Makefile
# test target uses Compose which is available on Windows, Unix, MacOS (requisite for the 3 Musketeers)
test: $(GOLANG_DEPS_DIR)
	$(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

# _test target depends on a go environment which may not be available on the host but it is executed in a Docker container. If you have a go environment on your host, `$ make test` can also be called.
_test:
	go test
.PHONY: _test
```

## .PHONY

> However, sometimes you want your Makefile to run commands that do not represent physical files in the file system. Good examples for this are the common targets "clean" and "all". Chances are this isn't the case, but you may potentially have a file named clean in your main directory. In such a case Make will be confused because by default the clean target would be associated with this file and Make will only run it when the file doesn't appear to be up-to-date with regards to its dependencies.
\- _from [stackoverflow][phonyStackoverflow]_

By being explicit it makes it clear which targets are not related to the file system.

## Docker and Compose commands as variables

Docker and Compose commands can be assigned to variables.

```Makefile
COMPOSE_RUN_GOLANG = docker-compose run --rm golang
COMPOSE_RUN_SERVERLESS = docker-compose run --rm serverless

deps:
	$(COMPOSE_RUN_GOLANG) make _depsGo
	$(COMPOSE_RUN_SERVERLESS) make _zipGoDeps
.PHONY: deps
```

## Target dependencies

To make the Makefile easier to read, avoid having many target dependencies: `target: a b c`. Restrict the dependencies only to `target` and not `_target`. Even more, restrict `target` to file dependencies only. This allows one to call a specific target without worrying that other targets will be executed too.

Use [Pipeline targets](#pipeline-targets) as a way to describe the dependencies.

```Makefile
test: $(GOLANG_DEPS_DIR)
	$(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

_test:
	go test
.PHONY: _test
```

## Pipeline targets

Section [Target dependencies](#target-dependencies) suggests to limit target dependencies as mush as possible but there is one exception: pipeline targets.

Pipeline targets are targets that have a list of dependencies, usually other targets. They are often used in CI to reduce the number of Make call and keep the CI pipelines as lean as possible.

It is best having them at the top of the Makefile as they give an understanding of the application pipelines when reading the Makefile.

Example from [Docker Cookiecutter][dockerCookiecutter] which uses 2 stages in the GitLab pipeline.

```Makefile
stageTest: envfile build test clean
.PHONY: stageTest

stageTriggerDockerHubBuilds: envfile triggerDockerHubBuilds clean
.PHONY: stageTriggerDockerHubBuilds
```

## make & target all

Running only `$ make` will trigger the first target from the Makefile. A convention among developer is to have a target `all` as the first target. In the 3 Musketeers context, `all` would be a perfect [pipeline target](#pipeline-targets) to document and test locally the sequence of target to test, build, run, etc.

## Target and Single Responsibility

It is a good idea to make the target as focus as possible on a specific task. This leaves the flexibility to anyone to test/call each target individually for a single purpose. The responsibility of a [pipeline target](#pipeline-targets) is to get the right order of targets to call to execute a specific task.

```Makefile
all: deps test build pack clean
.PHONY: all
```

## Target: envfile

The target `envfile` creates the file `.env` which is very useful for a project that follows the 3 Musketeers pattern. See [Environment Variables & envfile][environmentVariables].

```Makefile
# ENVFILE is .env.template by default but can be overwritten
ENVFILE ?= .env.template

# envfile creates or overwrites .env with $(ENVFILE)
envfile:
	cp -f $(ENVFILE) .env
.PHONY: envfile
```

```bash
# create a .env file the default file (.env.template)
$ make envfile
# create a .env file using file your.envfile
$ make envfile ENVFILE=your.envfile
```

Also a tool like [envvars][envvars] can be used.

## Calling multiple targets in a single command

Make allows you to call multiple targets in a single command like this `$ make targetA targetB targetC`. This is useful if you want to use a different `.env` file and call another target

```bash
# create .env with the default
$ make envfile anotherTarget
# create .env from another file
$ make envfile anotherTarget ENVFILE=your.envfile
```

## Prevent echoing the command

The symbol `@` tells Make to not echo the command prior execution. Useful when there are secrets at stake. [Docker Musketeers][dockerMusketeers] is a good example where `@` is used. If omitted, `DOCKERHUB_TRIGGER_URL`, which has a token in the URL, would be printed out in the logs.

```Makefile
_triggerDockerHubBuildForTagLatest:
	@curl -H "Content-Type: application/json" --data '{"docker_tag": "latest"}' -X POST $(DOCKERHUB_TRIGGER_URL)
.PHONY: _triggerDockerHubBuildForTagLatest
```

## Continue on error

The symbol `-` allows the execution to continue even if the command failed. [Envvars' tag target][envvarsTagTarget] illustrates it well where an existent tag can be re-tagged.

```Makefile
_tag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)
.PHONY: _tag
```

## Clean Docker and files

Using Compose creates a network that you may want to remove after your pipeline is done. You may also want to remove existing stopped and running containers. Moreover, files and folders that have been created can also be cleaned up after. A pipeline would maybe contain a stage clean or call clean after `test` for instance: `$ make test clean`.

`clean` could also have the command to clean Docker. However having the target `cleanDocker` may be very useful for targets that want to only clean the containers. See section "Managing containers in target".

It may happen that you face a permission issue like the following

```
rm -fr bin vendor
rm: cannot remove ‘vendor/gopkg.in/yaml.v2/README.md’: Permission denied
```

This happens because the creation of those files was done with a different user (in a container as root) and the current user does not have permission to delete them. One way to mitigate this is to call the command in the docker container.

```Makefile
cleanDocker:
	docker-compose down --remove-orphans
.PHONY: cleanDocker

clean:
	$(COMPOSE_RUN_GOLANG) make _clean
	$(MAKE) cleanDocker
.PHONY: clean

_clean:
	rm -fr files folders
.PHONY: clean
```

## Managing containers in target

Sometimes, target needs running containers in order to be executed. Once common example is for testing. Let's say `make test` needs a database to run in order to execute the tests.

### Starting

A target `startPostgres` which starts a database container can be used as a dependency to the target test.

```Makefile
startPostgres:
	docker-compose up -d postgres
	sleep 10
.PHONY: startPostgres
```

### Target test with cleanDocker

Once the test target finishes, the database would be still running. So it is a good idea to not let it running. The target `test` can run `cleanDocker` to remove the running database container. See "Clean Docker and files" section.

```Makefile
test: cleanDocker startPostgres
	...
	$(MAKE) cleanDocker
.PHONY: test
```

## Project dependencies

It is a good thing to have a target `deps` to install all the dependencies required to test, build, and deploy an application.

Create a tar file as an artifact for dependencies to be passed along through the stages. This step is quite useful as it acts as a cache and means subsequent CI/CD agents don’t need to re-install the dependencies again when testing and building.

```Makefile
COMPOSE_RUN_GOLANG=docker-compose run --rm golang
GOLANG_DEPS_DIR=vendor
GOLANG_DEPS_ARTIFACT=$(GOLANG_DEPS_DIR).tar.gz

# deps will create the folder vendor and the file vendor.tar.gz
deps:
	$(COMPOSE_RUN_GOLANG) make _depsGo _packGoDeps
.PHONY: deps

# test requires the folder vendor
test: $(GOLANG_DEPS_DIR)
	$(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

# if folder vendor exist, do nothing
# if folder vendor does not exist, unpack file vendor.tar.gz
# if file vendor.tar.gz does not exist, fail
$(GOLANG_DEPS_DIR): | $(GOLANG_DEPS_ARTIFACT)
	$(COMPOSE_RUN_GOLANG) make _unpackGoDeps

_depsGo:
	dep ensure
.PHONY: _depsGo

_packGoDeps:
	rm -f $(GOLANG_DEPS_ARTIFACT)
	tar czf $(GOLANG_DEPS_ARTIFACT) $(GOLANG_DEPS_DIR)
.PHONY: _packGoDeps

_unpackGoDeps:
	rm -fr $(GOLANG_DEPS_DIR)
	tar -xzf $(GOLANG_DEPS_ARTIFACT)
.PHONY: _unpackGoDeps
```

## Makefile too big

The Makefile can be split into smaller files if it becomes unreadable.

```Makefile
# Makefiles/test.mk
test: $(GOLANG_DEPS_DIR)
	$(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

_test:
	go test
.PHONY: _test

# Makefile
include Makefiles/*.mk
```

## Complex targets

Sometimes, target may become very complex due to the syntax and limitations of Make. Refer to the [patterns][] section for other alternatives.

## Self-Documented Makefile

[This][selfDocumentedMakefileGist] is pretty neat for self-documenting the Makefile.

```Makefile
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
DOCKER_RUN_MUSKETEERS = docker run --rm -v $(PWD):/opt/app -w /opt/app flemay/musketeers

help:           ## Show this help.
	$(DOCKER_RUN_MUSKETEERS) make _help
.PHONY: help

_help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
.PHONY: _help

# Everything below is an example

target00:       ## This message will show up when typing 'make help'
	@echo does nothing
.PHONY: target00

target01:       ## This message will also show up when typing 'make help'
	@echo does something
.PHONY: target01

# Remember that targets can have multiple entries (if your target specifications are very long, etc.)
target02:       ## This message will show up too!!!
target02: target00 target01
	@echo does even more
.PHONY: target02
```

```bash
# Output
help: Show this help.
target00: This message will show up when typing 'make help'
target01: This message will also show up when typing 'make help'
target02: This message will show up too!!!
```

[musketeersLambdaGoServerless]: https://gitlab.com/flemay/cookiecutter-musketeers-lambda-go-serverless/
[phonyStackoverflow]: https://stackoverflow.com/questions/2145590/what-is-the-purpose-of-phony-in-a-makefile#2145605/
[dockerCookiecutter]: https://gitlab.com/flemay/docker-cookiecutter
[envvars]: https://github.com/flemay/envvars
[dockerMusketeers]: https://github.com/flemay/docker-musketeers/blob/master/Makefile
[envvarsTagTarget]: https://github.com/flemay/envvars/blob/master/Makefile
[selfDocumentedMakefileGist]: https://gist.github.com/prwhite/8168133
[patterns]: ../patterns
[environmentVariables]: ../environment-variables
