# Guidelines

> The code snippets in this document are taken from the [Lambda Go Serverless](https://github.com/flemay/3musketeers/tree/master/examples/lambda-go-serverless) example.

## Makefile

### target vs _target

Using `target` and `_target` is a naming convention to distinguish targets that can be called on any platform (Windows, Linux, MacOS) versus those that need specific environment/dependencies.

```Makefile
# .env target uses cp which is available in Windows, Unix, MacOS
.env:
  cp .env.template .env

# test target uses Compose which is available on Windows, Unix, MacOS (requisite for the 3 Musketeers)
test: $(ENVFILE_TARGET) $(GOLANG_DEPS_DIR)
  docker-compose run --rm golang make _test
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
  cp .env.template .env

# test is not a file based target and specifying .PHONY will not conflict with a file or folder test
test: $(ENVFILE_TARGET) $(GOLANG_DEPS_DIR)
  docker-compose run --rm golang make _test
.PHONY: test
```

### Target dependencies

To make the Makefile easier to read avoid having many target dependencies: `target: a b c`. Restrict the dependencies only to `target` and not `_target`

```Makefile
test: $(ENVFILE_TARGET) $(GOLANG_DEPS_DIR)
  docker-compose run --rm serverlessGo make _test
.PHONY: test

_test:
  go test
.PHONY: _test
```

### Managing containers in target

Sometimes, target needs running containers in order to be executed. Once common example is for testing. Let's say `make test` needs a database to run in order to execute the tests.

#### Starting

A target `startPostgres` which starts a database container can be used as a dependency to the target test.

```Makefile
startPostgres:
  docker-compose up -d postgres
  sleep 10
.PHONY: startPostgres
```

#### Stopping/Cleaning

Once the test target finishes, the database would be still running. So it is a good idea to not let it running. A target that removes all countainers can help us.

```Makefile
removeContainers:
	docker-compose down --remove-orphans
.PHONY: removeContainers
```

#### Target test

```Makefile
test: removeContainers startPostgres
	...
	$(MAKE) removeContainers
.PHONY: test
```

#### Target clean

A target `clean` could also be used to remove the docker containers with docker network created with Compose. It could remove files and folders too.

### Pipeline targets

Pipeline targets are targets being executed on the CI/CD server. A typical pipeline targets would have `deps, test, build, deploy`.

It is best having them at the top of the Makefile as it gives an understanding of the application pipeline when reading the Makefile.

### Project dependencies

It is a good thing to have a target `deps` to install all the dependencies required to test, build, and deploy an application.

Create an artifact as a zip file for dependencies to be passed along through the stages. This step is quite useful as it acts as a cache and means subsequent CI/CD agents don’t need to re-install the dependencies again when testing and building.

```Makefile
deps: $(ENVFILE_TARGET)
  docker-compose run --rm golang make _depsGo
.PHONY: deps

test: $(ENVFILE_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm golang make _test
.PHONY: test

$(GOLANG_DEPS_DIR): $(GOLANG_DEPS_ARTIFACT)
  unzip -qo -d . $(GOLANG_DEPS_ARTIFACT)

_depsGo:
  dep ensure
  zip -rq $(GOLANG_DEPS_ARTIFACT) $(GOLANG_DEPS_DIR)/
.PHONY: _depsGo
```

### Makefile too big?

The Makefile can be split into smaller files if it becomes unreadable.

```Makefile
# Makefiles/test.mk
test: $(ENVFILE_TARGET) $(GOLANG_DEPS_DIR)
  docker-compose run --rm serverlessGo make _test
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

## .env

`.env` is used to pass environment variables to Docker containers. To know more about it, please read [envfile/README.md](https://github.com/flemay/3musketeers/blob/master/envfile/README.md).

### .env.template

Contains names of all environment variables the application and pipeline use. No values are set here. `.env.template` is meant to serve as a template to `.env`. If there is no `.env` in the directory and `ENVFILE` is not specified, Make will create a `.env` file with `.env.template`.

### .env.example

`.env.example` defines values so that it can be used straight away with Make like `$ make test ENVFILE=.env.example`. It also gives an example of values that is being used in the project.

> Never include sensitive values like passwords as this file is meant to be checked in.

### AWS environment variables vs ~/.aws

In the examples, `.env.template` contains the following environment variables:

```
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
AWS_PROFILE
```

If you are using ~/.aws, no need to set values and they won't be included in the Docker container. If there is a value for any of the environment variables, it will have precedence over ~/.aws when using aws cli.

## Compose

### Composition over Inheritance

With Docker, it is pretty easy to have all the tooling a project needs inside one image. However, if the project requires a new dependency, the image would need to be modified, tested, and rebuilt. In order to avoid this, use dedicated images that do specific things.
