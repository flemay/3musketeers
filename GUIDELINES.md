# Guidelines

> Most of the code snippets in this document are taken from the [Lambda Go Serverless Makefile](examples/lambda-go-serverless/Makefile) example.

## Managing environment variables

Development following [the twelve-factor app](https://12factor.net) use the [environment variables to configure](https://12factor.net/config) their application.

Often there are many environment variables and having them in a `.env` file becomes handy. Docker and Compose do use [environment variables file](https://docs.docker.com/compose/env-file/) to pass the variables to the containers.

Read [envfile/README.md](envfile/README.md) for more information about ways to manage environments variables with files.

### AWS environment variables vs ~/.aws

In the lambda example, [envvars.yml](examples/lambda-go-serverless/envvars.yml) contains the following optional environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, and `AWS_PROFILE`. Also, the [docker-compose.yml](examples/lambda-go-serverless/docker-compose.yml) mounts the volume `~/.aws`.

If you are using `~/.aws`, no need to set values and they won't be included in the Docker container. If there is a value for any of the environment variables, it will have precedence over ~/.aws when using aws cli.

## Makefile

### Useful Makefile variables

#### Docker and Compose commands

Docker and Compose commands can be assigned to variables.

```Makefile
COMPOSE_RUN_GOLANG = docker-compose run --rm golang
COMPOSE_RUN_SERVERLESS = docker-compose run --rm serverless

deps: $(ENVFILE)
  $(COMPOSE_RUN_GOLANG) make _depsGo
  $(COMPOSE_RUN_SERVERLESS) make _zipGoDeps
.PHONY: deps
```

### Target all

Target all is a good way to document (and test locally) the sequence of the targets to test, build, run, etc. Target all can simply run with `$ make`.

```Makefile
all: clean deps test build pack
.PHONY: all
```

### target vs _target

Using `target` and `_target` is a naming convention to distinguish targets that can be called on any platform (Windows, Linux, MacOS) versus those that need specific environment/dependencies.

```Makefile
# test target uses Compose which is available on Windows, Unix, MacOS (requisite for the 3 Musketeers)
test: $(ENVFILE) $(GOLANG_DEPS_DIR)
  $(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

# _test target depends on a go environment which may not be available on the host but it is executed in a Docker container. If you have a go environment on your host, `$ make test` can also be called.
_test:
  go test
.PHONY: _test
```

### .PHONY

> However, sometimes you want your Makefile to run commands that do not represent physical files in the file system. Good examples for this are the common targets "clean" and "all". Chances are this isn't the case, but you may potentially have a file named clean in your main directory. In such a case Make will be confused because by default the clean target would be associated with this file and Make will only run it when the file doesn't appear to be up-to-date with regards to its dependencies.
\- _from [stackoverflow](https://stackoverflow.com/questions/2145590/what-is-the-purpose-of-phony-in-a-makefile#2145605)_

By being explicit it makes it clear which targets are not related to the file system.

```Makefile
# .env is file based target. It creates a .env file if it does not exist
.env:
  $(ENVVARS_CMD) envfile

# test is not a file based target and specifying .PHONY will not conflict with a file or folder test
test: $(ENVFILE) $(GOLANG_DEPS_DIR)
  $(COMPOSE_RUN_GOLANG) make _test
.PHONY: test
```

### Target dependencies

To make the Makefile easier to read, avoid having many target dependencies: `target: a b c`. Restrict the dependencies only to `target` and not `_target`.

```Makefile
test: $(ENVFILE) $(GOLANG_DEPS_DIR)
  $(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

_test:
  go test
.PHONY: _test
```

### Clean Docker and files

Using Compose creates a network that you may want to remove after your pipeline is done. You may also want to remove existing stopped and running containers. Moreover, files and folders that have been created can also be cleaned up after. A pipeline would maybe contain a stage clean or call clean after `test` for instance: `$ make test clean`.

`clean` could also have the command to clean Docker. However having the target `cleanDocker` may be very useful for targets that want to only clean the containers. See section "Managing containers in target".

It may happen that you face a permission issue like the following

```
rm -fr bin vendor
rm: cannot remove ‘vendor/gopkg.in/yaml.v2/README.md’: Permission denied
```

This happens because the creation of those files was done with a different user (in a container as root) and the current user does not have permission to delete them. One way to mitigate this is to call the command in the docker container.

```Makefile
cleanDocker: $(ENVFILE)
  docker-compose down --remove-orphans
.PHONY: cleanDocker

clean: $(ENVFILE)
  $(COMPOSE_RUN_GOLANG) make _clean
  $(MAKE) cleanDocker
.PHONY: clean

_clean:
  rm -fr files folders
.PHONY: clean
```

### Managing containers in target

Sometimes, target needs running containers in order to be executed. Once common example is for testing. Let's say `make test` needs a database to run in order to execute the tests.

#### Starting

A target `startPostgres` which starts a database container can be used as a dependency to the target test.

```Makefile
startPostgres: $(ENVFILE)
  docker-compose up -d postgres
  sleep 10
.PHONY: startPostgres
```

#### Target test with cleanDocker

Once the test target finishes, the database would be still running. So it is a good idea to not let it running. The target `test` can run `cleanDocker` to remove the running database container. See "Clean Docker and files" section.

```Makefile
test: cleanDocker startPostgres
  ...
  $(MAKE) cleanDocker
.PHONY: test
```

### Pipeline targets

Pipeline targets are targets being executed on the CI/CD server. A typical pipeline targets would have `deps, test, build, deploy`.

It is best having them at the top of the Makefile as it gives an understanding of the application pipeline when reading the Makefile.

### Project dependencies

It is a good thing to have a target `deps` to install all the dependencies required to test, build, and deploy an application.

Create an artifact as a zip file for dependencies to be passed along through the stages. This step is quite useful as it acts as a cache and means subsequent CI/CD agents don’t need to re-install the dependencies again when testing and building.

```Makefile
deps: $(ENVFILE)
  $(COMPOSE_RUN_GOLANG) make _depsGo
  $(COMPOSE_RUN_SERVERLESS) make _zipGoDeps
.PHONY: deps

test: $(ENVFILE) $(GOLANG_DEPS_DIR)
  $(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

$(GOLANG_DEPS_DIR): | $(GOLANG_DEPS_ARTIFACT)
  $(COMPOSE_RUN_SERVERLESS) make _unzipGoDeps

_depsGo:
  dep ensure
.PHONY: _depsGo

_zipGoDeps:
	zip -rq $(GOLANG_DEPS_ARTIFACT) $(GOLANG_DEPS_DIR)/
.PHONY: _zipGoDeps

_unzipGoDeps:
	unzip -qo -d . $(GOLANG_DEPS_ARTIFACT)
.PHONY: _unzipGoDeps
```

### Makefile too big?

The Makefile can be split into smaller files if it becomes unreadable.

```Makefile
# Makefiles/test.mk
test: $(ENVFILE) $(GOLANG_DEPS_DIR)
  $(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

_test:
  go test
.PHONY: _test

# Makefile
include Makefiles/*.mk
```

### Complex targets

Sometimes target may become very complex due to the syntax and limitations of Make. A way to make it simpler and cleaner is to create a shell script file and call it from the target.

```Makefile
# _target executes a shell script from the scripts folder
_target:
  ./scripts/dosomething.sh
.PHONY: _target
```

## Docker

### Image without make

The 3 Musketeers suggests to call `make` from Compose but not all images out there have `make` out of the box. Here are few ways to handle this situation.

#### Use a different image

Often image publishers offer different versions of the application/product. For instance [golang](https://hub.docker.com/_/golang/) has an image based on `alpine` which does not have `make`. It also has an image based on `stretch` which has `make`.

```bash
$ docker run --rm golang:alpine make
# "exec: \"make\": executable file not found
$ docker run --rm golang:stretch make
# make: *** No targets specified and no makefile found
```

#### Install make on the fly

Whenever a command runs a command it installs `make` and then execute `$ make _target`. Depending on how many time a command is run, this way may be very inefficient as it needs to download `make` every single time.

```bash
$ docker run --rm golang:alpine apk add --update make && make _target
```

#### Build your own image

You may want to build and maintain your own image based on the the image you wanted to use.

```Dockerfile
FROM golang:alpine
RUN apk add --update make
...
```

#### Use scripts

Using bash/shell scripts is also a good alternative to using `make`. `$ make target` can call Docker/Compose to execute a script (either inline or a file) instead of `make _target`. As part of the 3 Musketeers philosophy, it is important that the scripts are being tested locally as well.

```bash
# inline
$ docker run --rm golang:alpine echo Hello World
# script file
$ docker run --rm -v $ENV:/opt/app -w /opt/app golang:alpine ./path/to/script.sh
```

## Compose

### Composition over Inheritance

With Docker, it is pretty easy to have all the tooling a project needs inside one image. However, if the project requires a new dependency, the image would need to be modified, tested, and rebuilt. In order to avoid this, use dedicated images that do specific things.
