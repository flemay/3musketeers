# The Three Musketeers

## Guideline

### Makefile

#### naming target vs _target

This is just a naming convention. `target` is meant to be executed with docker and docker compose whereas `_target` is meant to be executed inside a container or locally.

#### target dependencies

To make the Makefile easier to read avoid having many target dependencies: `target: a b c`. Restrict the dependencies only to `target` and not `_target`

#### Targets to represent the Pipeline

The first section of the Makefile often has targets which represent the pipeline: `deps`, `test`, `build`, `deploy`. These targets will be run in the CI.

#### Project Dependencies

It is a good thing to have a target `deps` to install all the dependencies required to test/build/deploy the project.

Create zip artifact(s) like `node_modules.zip` so that the CI can carry it across tasks. Use this artifact(s) to be a dependency to other targets so if it does not exist, the targets will fail.

```Makefile
# TODO
deps:
  ...
.PHONY: deps

test: node_modules

.PHONY: test

node_modules:
```

### .env

#### .env.template



#### .env.example

Very useful when starting on a project to have a `.env.example` which has defined values so that you can for instance run the test straight away with `$ make test DOTENV=.env.example`.

### Docker Compose
