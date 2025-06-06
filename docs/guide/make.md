# Make

Make is a cross-platform build tool to test and build software and it is used as an interface between the CI/CD server and the application code. A single Makefile per application defines and encapsulates all the steps for testing, building, and deploying that application. Of course other tools like rake or ant can be used to achieve the same goal, but having Makefile pre-installed in many OS distributions makes it a convenient choice

Having a clean `Makefile` is key. It helps to understand it quickly and is easier to maintain. Therefore, having some conventions like [target vs _target][linkTargetVSUnderscoreTarget], and [Pipeline targets][linkPipelineTargets] really aim to make the developer's life easier. The conventions are for the context of the 3 Musketeers.

> [!NOTE]
> * The snippets in this section bring support for the documentation and are expected to be incomplete.
> * [Makefile Tutorial](https://makefiletutorial.com/) is a great place to learn more about Make and Makefile.

## target vs _target

> [!NOTE]
> This is mainly when using [Make in a pattern][linkPatternsMake].

Using `target` and `_target` is a naming convention to distinguish targets that can be called on any platform (Windows, Linux, MacOS) versus those that need specific environment/dependencies.

```make
# Makefile
# Target `deploy` uses Compose which is available on Windows, Unix, and MacOS
deploy:
	docker compose run --rm serverless make _deploy

# Target `_deploy` depends on a NodeJS environment and Serverless Framework which may not be available on the hosts.
# It is executed in a Docker container that provides the right environment for its execution.
# If the host has NodeJS and Serverless Framework installed, `make _build` can be called.
_deploy:
	serverless deploy
```

## .PHONY

> A phony target is one that is not really the name of a file; rather it is just a name for a recipe to be executed when you make an explicit request. There are two reasons to use a phony target: to avoid a conflict with a file of the same name, and to improve performance. - [GNU][linkPhony]

By default `.PHONY` can be left out unless the target collides with the name of file/folder. One case is a target `test` which often conflicts with a folder named `test`.

```make
# Makefile
# can be written into a single line with other targets that need .PHONY
.PHONY: test targetA targetB

test:
	docker compose run --rm node make _test
.PHONY: test # can be put here for the target test

_test:
	npx jest
```

Sometimes you want the target to match the name of a file in which case `.PHONY` would not be used. See [Environment variables & .env file][linkEnvironmentVariables] for an example.

## Target dependencies

To make the Makefile easier to read, avoid having many target dependencies: `target: a b c`. Restrict the dependencies only to `target` and not `_target`. Even more, restrict `target` to file dependencies only. This allows one to call a specific target without worrying that other targets will be executed too.

> [!NOTE]
> Use [Pipeline targets][linkPipelineTargets] as a way to describe the list of dependencies.

```make
# Makefile
deploy: package.zip
	$(COMPOSE_RUN_NODE) make _deploy
```

## Pipeline targets

Section [Target dependencies][linkTargetDependencies] suggests to limit target dependencies as mush as possible but there is one exception: pipeline targets.

We call pipeline targets the targets that have a list of dependencies, usually other targets. They are often used in CI to reduce the number of Make calls and keep the CI pipelines clean.

It is best having them at the top of the Makefile as they give an understanding of the application pipelines when reading the Makefile.

```make
# Makefile
# Pipeline targets first
stageTest: build test clean

# other targets below
```

## Target `all`

Running only `make` will trigger the first target from the Makefile. A convention among developer is to have a target `all` as the first target. In the 3 Musketeers context, `all` is a perfect [pipeline target][linkPipelineTargets] to document and test locally the sequence of targets to test, build, run, etc.

```make
# Makefile
# First target
all: deps test build clean

# other targets below
```

```sh
# Run target `all`
make all
# Or
make
```

## Target `noTargetGuard`

Another option to handle `make` with no target is to have the first target to return an error. Something like

```make
# Makefile
# First target
noTargetGuard:
  @echo "Error: target is required"
  exit 1

# other targets below
```

```sh
make
# Error: target required
# exit 1
# make: *** [noTargetGuard] Error 1
```

## Ordering targets

Ordering targets in some ways may help maintaining the Makefile in the long run. Here are some suggestions:

- Variables defined at the top
- Targets [all][linkMakeAndTargetAll] and [pipeline target][linkPipelineTargets] at the top of the file (after the variables)
- Ordering targets in a build pipeline flow

```make
# Makefile
deps:
	# ...
test:
	# ...
build:
	# ...
deploy:
	# ...
```

- Group [target and _target][linkTargetVSUnderscoreTarget] together

```make
# Makefile
DOCKER_RUN = docker run -it -v $(PWD)/Makefile:/go/Makefile --rm golang

deps:
	$(DOCKER_RUN) make _deps
_deps:
	@echo "_deps"

test:
	$(DOCKER_RUN) make _test
_test:
	@echo "_test"
```

- Alternatively, [target and _target][linkTargetVSUnderscoreTarget] can be separated if too verbose.

```make
# Makefile
DOCKER_RUN = docker run -it -v $(PWD)/Makefile:/go/Makefile --rm golang

deps:
	$(DOCKER_RUN) make _deps
test:
	$(DOCKER_RUN) make _test

_deps:
	@echo "_deps"
_test:
	@echo "_test"
```

## Reduce repetitiveness

### Docker and Compose commands as variables

Docker and Compose commands can be assigned to variables.

```make
# Makefile
DOCKER_RUN = docker run -it -v $(PWD)/Makefile:/go/Makefile --rm golang

deploy:
	$(DOCKER_RUN) make _deploy
_deploy:
	@echo "_deploy"
```

### Group targets

Sometimes it may be redundant to always define a `target` that just calls `_target`.

One option is the following:

```make
# Makefile
DOCKER_RUN = docker run -it -v $(PWD)/Makefile:/go/Makefile --rm golang

deps build deploy:
	$(DOCKER_RUN) make _$@

_deps:
	@echo "_deps"
_build:
	@echo "_build"
_deploy:
	@echo "_deploy"
```

Or using multiple lines:

```make
# Makefile
DOCKER_RUN = docker run -it -v $(PWD)/Makefile:/go/Makefile --rm golang

deps \
build \
deploy:
	$(DOCKER_RUN) make _$@

_deps:
	@echo "_deps"
_build:
	@echo "_build"
_deploy:
	@echo "_deploy"
```

```sh
make deps
#docker run -it -v /tmp/maketest/Makefile:/go/Makefile --rm golang make _deps
#_deps
```

### Catch-all with `.DEFAULT`

Another option, although less explicit, is to use a catch-all:

```make
# Makefile
 DOCKER_RUN = docker run -it -v $(PWD)/Makefile:/go/Makefile --rm golang

.DEFAULT:
	@echo "Target '$<' is in catch-all"
	$(DOCKER_RUN) make _$<

_deps:
	@echo "_deps"
_build:
	@echo "_build"
_deploy:
	@echo "_deploy"
test:
	@echo "Target 'test' is not in catch-all"
	$(DOCKER_RUN) make _test
_test:
	@echo "_test"
```

```sh
make deps
# Target 'deps' is in catch-all
# docker run -it -v /tmp/maketest/Makefile:/go/Makefile --rm golang make _deps
# _deps

make test
# Target 'test' is not in catch-all
# docker run -it -v /tmp/maketest/Makefile:/go/Makefile --rm golang make _test
# _test
```

## Target and single responsibility

It is a good idea to make the target as focus as possible on a specific task. This leaves the flexibility to anyone to manually test/call each target individually for a single purpose.

Targets can be composed as a [pipeline target][linkPipelineTargets] which ensures the right order of targets to call for executing a specific task.

## Idempotency

Ideally, a target should be idempotent so that the result of running it once is the same as running it multiple times.

## Targets .env and envfile

The target `envfile` creates the file `.env` which is very useful for a project that follows the 3 Musketeers pattern. Refer to section [Environment Variables][linkEnvironmentVariables] for more details.

## Project dependencies

> [!NOTE]
> Refer to [project dependencies][linkProjectDependencies] section for more information.

It is a good thing to have a target `deps` for installing all the dependencies required to test, build, and deploy an application.

A tar file of the dependencies can be created as an artifact to be passed along through the CI/CD stages. This step is useful as it acts as a cache. Subsequent CI/CD stages will have the exact same dependencies. Moreover, it is faster to pass along a tar file than a folder with many files.

```make
# Makefile
COMPOSE_RUN_NODE = docker compose run --rm node
DEPS_DIRS = node_modules
DEPS_ARTIFACT = $(DEPS_DIRS).tar.gz

deps:
	$(COMPOSE_RUN_NODE) make _depsNPMInstall

depsPack:
	$(COMPOSE_RUN_NODE) make _packDeps

depsUnpack:
	$(COMPOSE_RUN_NODE) make _unpackDeps

_depsNPMInstall:
	npm install

_depsPack:
	rm -f $(DEPS_ARTIFACT)
	tar -czf $(DEPS_ARTIFACT) $(DEPS_DIRS)

_depsUnpack: $(DEPS_ARTIFACT)
	rm -fr $(DEPS_DIRS)
	tar -xzf $(DEPS_ARTIFACT)
```

It is up to the CI/CD pipeline to call the targets **explicitly** in the right order, i.e: `make deps depsPack` and `make depsUnpack test`. Alternatively, the Makefile can have targets like `ciDeps: deps depsPack` and `ciTest: depsUnpack test`.

> [!NOTE] DEPS_DIRS
> DEPS_DIRS is language agnostic and can include many directories:
> DEPS_DIRS = node_modules vendor packages/**/dist/*

## Calling multiple targets in a single command

Make allows you to call multiple targets in a single command like this `make targetA targetB targetC`. This is useful if you want to use a different `.env` file and call another target

```bash
# create .env with the default
make envfile anotherTarget
# create .env from another file
make envfile anotherTarget ENVFILE=your.envfile
```

## Prevent echoing the command

The symbol `@` prevents the command to be printed out prior its execution. Useful when there are secrets at stake.

```make
# Makefile
# If '@ 'is omitted, `DOCKER_PASSWORD` would be revealed.
push:
	@echo "$(DOCKER_PASSWORD)" | docker login --username "$(DOCKER_USERNAME)" --password-stdin docker.io
	docker push $(IMAGE)
	docker logout
```

## Continue on error

The symbol `-` allows the execution to continue even if the command failed.

```make
# Makefile
TAG=v1.0.0

# _tag creates a new tag and fails if the tag already exists
_tag:
	git tag $(TAG)
	git push origin $(TAG)

# _overwriteTag creates a new tag or re-tags the existing one
_overwriteTag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)
```

## Clean Docker and files

Using Compose creates a network that you may want to remove after your stage or pipeline is completed. You may also want to remove existing stopped and running containers. Moreover, files and folders that have been created can also be cleaned up after. A pipeline would maybe contain a stage clean or call clean after `test` for instance: `make test clean`.

`clean` could also have the command to clean Docker. However having the target `cleanDocker` may be very useful for targets that want to only clean the containers. See section [Managing containers in target][linkManagingContainersInTarget].

It may happen that you face a permission issue like the following

```
rm -fr bin vendor
rm: cannot remove ‘vendor/gopkg.in/yaml.v2/README.md’: Permission denied
```

This happens because the creation of those files was done with a different user (in a container as root) and the current user does not have permission to delete them. One way to mitigate this is to call the command in the docker container.

```make
# Makefile
cleanDocker:
	docker compose down --remove-orphans

clean:
	$(COMPOSE_RUN_GOLANG) make _clean
	$(MAKE) cleanDocker

_clean:
	rm -fr files folders
```

## Managing containers in target

Sometimes a target needs to run a container in order to execute its task.

For instance, a target `test` may need a database to run prior executing the tests.

```make
# Makefile
# target test calls cleanDocker before starting a postgres container
test: cleanDocker startPostgres
	$(DOCKER_RUN_NODE) make _test
	# cleanDocker stops the postgrest container and removes it
	$(MAKE) cleanDocker
.PHONY: test

postgresStart:
	docker compose up -d postgres
	sleep 10

cleanDocker:
	docker compose down --remove-orphans
```

## Multiple makefiles

The Makefile can be split into smaller files.

```make
# Makefile
# makefiles/deploy.mk
deploy:
	docker compose run --rm serverless make _deploy

_deploy:
	serverless deploy
```

```make
# Makefile
# Makefile
include makefiles/*.mk
```

## Complex targets

In some situations, targets become very complex due to the syntax and limitations of Make or you may simply prefer to write the task in Bash or other languages. Refer to section [patterns][linkPatterns] for other Make alternatives.

## Self-documented Makefile

[This][linkSelfDocumentedMakefileGist] is pretty neat for self-documenting the Makefile.

```make
# Makefile
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
DOCKER_RUN_MUSKETEERS = docker run --rm -v $(PWD):/opt/app -w /opt/app flemay/musketeers

help:           ## Show this help.
	$(DOCKER_RUN_MUSKETEERS) make _help

_help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

# Everything below is an example

target00:       ## This message will show up when typing 'make help'
	@echo does nothing

target01:       ## This message will also show up when typing 'make help'
	@echo does something

# Remember that targets can have multiple entries (if your target specifications are very long, etc.)
target02:       ## This message will show up too!!!
target02: target00 target01
	@echo does even more
```

```bash
# Output
help: Show this help.
target00: This message will show up when typing 'make help'
target01: This message will also show up when typing 'make help'
target02: This message will show up too!!!
```


[linkMakeAndTargetAll]: #make-and-target-all
[linkPipelineTargets]: #pipeline-targets
[linkTargetVSUnderscoreTarget]: #target-vs-_target
[linkTargetDependencies]: #target-dependencies
[linkManagingContainersInTarget]: #managing-containers-in-target

[linkPatterns]: patterns
[linkPatternsMake]: patterns#make
[linkEnvironmentVariables]: environment-variables
[linkProjectDependencies]: project-dependencies

[linkPhony]: https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
[linkSelfDocumentedMakefileGist]: https://gist.github.com/prwhite/8168133
