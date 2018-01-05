# The 3 Musketeers

## Guideline

> The code examples in this guideline can be found in [examples/golang-serverless](https://github.com/flemay/3musketeers/tree/master/examples/golang-serverless).

### Makefile

#### Names target and _target

This is just a naming convention. `target` is meant to be executed with docker and docker compose whereas `_target` inside a container.

`_target` can also be executed on the computer if the environment satisfies the target requirements. For instance, you can have a Go development environment setup locally and run `$ make _test`.

```Makefile
test: $(DOTENV_TARGET) $(GOLANG_DEPS_DIR)
  docker-compose run --rm goshim make _test
.PHONY: test

_test:
  go test -v
.PHONY: _test
```

#### Target dependencies

To make the Makefile easier to read avoid having many target dependencies: `target: a b c`. Restrict the dependencies only to `target` and not `_target`

#### Pipeline targets

Pipeline targets are targets being executed on the CI server. A typical pipeline targets would have `deps, test, build, deploy`.

It is best having them at the top of the Makefile as it gives an idea of the project pipeline and where to start when the project is being downloaded.

#### Project dependencies

It is a good thing to have a target `deps` to install all the dependencies required to test/build/deploy the project.

Create zip artifact(s) like `golang_vendor.zip` so that the CI can carry it across tasks. Use this artifact(s) to be a dependency to other targets so if it does not exist, the targets will fail.

```Makefile
deps: $(DOTENV_TARGET)
  docker-compose run --rm goshim make _depsGo
.PHONY: deps

test: $(DOTENV_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm goshim make _test
.PHONY: test

$(GOLANG_DEPS_DIR): $(GOLANG_DEPS_ARTIFACT)
  unzip -qo -d . $(GOLANG_DEPS_ARTIFACT)

_depsGo:
  dep ensure
  zip -rq $(GOLANG_DEPS_ARTIFACT) $(GOLANG_DEPS_DIR)/
.PHONY: _depsGo
```

### .env

`.env` is used to pass environment variables to Docker containers. To know more about it, please read [dotenv/README.md](https://github.com/flemay/3musketeers/blob/master/dotenv/README.md).

#### .env.template

Contains names of all environment variables the application and pipeline use. No values are set here. `.env.template` is meant to serve as a template to `.env`. If there is no `.env` in the directory and `DOTENV` is not specified, Make will create a `.env` file with `.env.template`.

#### .env.example

Very useful when starting on a project to have a `.env.example` which has defined values so that you can for instance run the test straight away with `$ make test DOTENV=.env.example`.

Never include sensitive values like passwords as this file is meant to be checked in.

#### AWS environment variables vs ~/.aws

In the examples, `.env.template` contains the following environment variables:

```
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
AWS_PROFILE
```

If you are using ~/.aws, no need to set values and they won't be included in the Docker container. If there is a value for any of the environment variables, it will have precedence over ~/.aws when using aws cli.

### Docker Compose
