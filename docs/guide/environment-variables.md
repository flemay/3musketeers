---
outline: 'deep'
---

# Environment variables

Development following [the twelve-factor app][link12factor] use the [environment variables to configure][link12factorConfig] their application.

Often there are many environment variables and having them in a `.env` file becomes handy. Docker and Compose do use [environment variables file][linkDockerEnvfile] to pass the variables to the containers.

::: info
The code in this section is expected to be fully functional.
:::

## Naming and envfile structure

Environment variables for an application can be mixed with other environment variables coming from other applications/dependencies. One way to distinguish from one to another is to prepend with something like `ENV_`. This makes it easy when you want to only see them: `env | grep ENV_`. One example is GitHub Actions as it uses [environment variables starting with `GITHUB_`][linkGitHubActionsEnvVars].

Also, environment variables can be used at different stages of software development: build, test, deploy, and run time. Naming them accordingly may be a good idea.

Naming variables and structuring envfile is a personal taste. Currently I prefer structuring it by ordering variables and descriptions:

```bash
# env.template

# ENV_MY_VAR_1 is description 1
# ENV_MY_VAR_2 is description 2
ENV_MY_VAR_1
ENV_MY_VAR_2
```

## Envfile and expectations

Given the file `.env`:

```bash
# .env
# Make sure these env vars are not set in the system
ENV_A
ENV_B=
ENV_C=env_c
```

And the file `docker-compose.yml`:

```yaml
# docker-compose.yml
services:
  alpine:
    image: alpine
    env_file: .env
```

The expected results are:

```bash
docker run --rm --env-file=.env alpine env
#ENV_B=
#ENV_C=env_c
# ENV_A is not set and ENV_B is set to empty

docker compose run --rm alpine env
#ENV_B=
#ENV_C=env_c
# Same as Docker
```

::: tip
Refer to section [Tutorial][linkSectionTutorial] for in-depth demonstration.
:::

## Template and example envfiles

`env.template` and `env.example` files provide some help when managing environment variables in a project.

::: danger ENVFILES AND SOURCE CONTROL
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

Given all environment variables are set in your CI/CD pipeline, creating a `.env` file based on `env.template` allows values of those environment variables to be passed to the Docker container environments.

::: tip
This is demonstrated in section [Tutorial][linkSectionTutorial]
:::

## Day-to-day development

In a day-to-day development process, you could create a file named `.env.dev` with the config of your dev environment and copy the contents of it into `.env` so that you can manually deploy/delete/etc your app for testing. This allows you to not accidentally lose the values if the `.env` file is replaced.
There are few ways to copy the contents of your file to `.env`:

- manually
- `make envfile ENVFILE=env.example` (refer to section [Create envfile][linkSectionCreateEnvfile])

## Create envfile

This section shows some ways to create `.env` file with Make and Docker/Compose.

### With Make and Compose

Given the file `env.template`:

```bash
# env.template
ENV_MY_VAR
```

And the file `env.example`:

```bash
# env.example
ENV_MY_VAR=MY_VALUE
```

And the file `docker-compose.yml`:

```yaml
# docker-compose.yml
version: "3.8"
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

::: info
The `docker-compose.yml` above has the [variable substitution][linkDockerComposeVarialeSubstitution] `env_file: ${ENVFILE:-.env}`, which allows the use of a different file that `.env` by defining the environment variable `ENVFILE`. This was required for using Compose otherwise Compose would simply fail. Examples in this section will use `.env` except when generating the file.
:::

#### Explicit

Targets requiring `.env` file will fail if the file does not exist. The `.env` file can be created with `envfile` target.

::: tip
Explicit is the method I prefer the most.
:::

```make
# Makefile
COMPOSE_RUN_ALPINE = docker-compose run alpine
ENVFILE ?= env.template

envfile:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) cp $(ENVFILE) .env

targetA:
	$(COMPOSE_RUN_ALPINE) cat .env

targetB: .env
    $(COMPOSE_RUN_ALPINE) cat .env

prune:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) rm -f .env
```

```bash
# Compose will return an error if .env does not exist because of `env_file: ${ENVFILE:-.env}`
make targetA
# Make will return an error if .env does not exist
make targetB
# Overwrite .env based on env.template. The reason why `make envfile` it call Compose with `ENVFILE=$(ENVFILE)`
make envfile
# Overwrite .env with env.example
make envfile ENVFILE=env.example
# Overwrite .env with env.example before running targetA
make envfile targetA ENVFILE=env.example
```

#### Semi-Implicit

Targets requiring `.env` file will get it created if it does not exist. The `.env` file can be overwritten by calling `make envfile ENVFILE=.env.example`.

```make
# Makefile
COMPOSE_RUN_ALPINE = docker-compose run alpine
ENVFILE ?= env.template

.env:
	$(MAKE) envfile

envfile:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) cp $(ENVFILE) .env

target: .env
	$(COMPOSE_RUN_ALPINE) cat .env

prune: .env
	$(COMPOSE_RUN_ALPINE) rm .env
```

```bash
# Create .env based on env.template if .env does not exist
make target
# Create .env based on env.template if .env does not exist
make .env
# Create .env based on $(ENVFILE) if .env does not exist
make .env ENVFILE=env.example
# Overwrite .env based on env.template
make envfile
# Overwrite .env with a specific file
make envfile ENVFILE=env.example
# Execute a target with a specific .env file
make envfile target ENVFILE=env.example
```

#### Implicit

Targets requiring `.env` file will get it created if it does not exist. The `.env` file can be overwritten by setting `ENVFILE` environment variable.

```makefile
# Makefile
COMPOSE_RUN_ALPINE = docker-compose run alpine
ifdef ENVFILE
	ENVFILE_TARGET=envfile
else
	ENVFILE_TARGET=.env
endif

.env:
	$(MAKE) envfile ENVFILE=env.template

envfile:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) cp $(ENVFILE) .env

target: $(ENVFILE_TARGET)
	$(COMPOSE_RUN_ALPINE) cat .env

prune: $(ENVFILE_TARGET)
  $(COMPOSE_RUN_ALPINE) rm .env
```

```bash
# Create .env based on env.template if .env does not exist
make target
# Create .env based on env.template if .env does not exist
make .env
# Create .env based on env.example if .env does not exist
make .env ENVFILE=env.example
# Overwrite .env with env.example
make envfile ENVFILE=env.example
# Execute a target with env.example
make envfile target ENVFILE=env.example
# Or (no need to specify envfile)
make target ENVFILE=env.example
```

### With Make and Docker

Everything covered in section [With Make and Compose][linkSectionWithMakeAndCompose] can be applied here except Docker won't use `docker-compose.yml`. Here's an example with the explicit method:

```makefile
# Makefile
MAKEFILE_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
DOCKER_RUN_ALPINE = docker run --rm \
	-v $(MAKEFILE_DIR):/opt/app \
	-w /opt/app \
	alpine
DOCKER_RUN_ALPINE_WITH_ENVFILE = docker run --rm \
	-v $(MAKEFILE_DIR):/opt/app \
	-w /opt/app \
	--env-file .env \
	alpine
ENVFILE ?= env.template

envfile:
	$(DOCKER_RUN_ALPINE) cp $(ENVFILE) .env

targetA:
	$(DOCKER_RUN_ALPINE_WITH_ENVFILE) cat .env

targetB: .env
	$(DOCKER_RUN_ALPINE_WITH_ENVFILE) cat .env

prune:
	$(DOCKER_RUN_ALPINE) rm .env
```

```bash
# Docker will return an error if .env does not exist
make targetA
# Make will return an error if .env does not exist
make targetB
# Overwrite .env based on env.template. The reason why it does not fail is because it uses `DOCKER_RUN_ALPINE`
make envfile
# Overwrite .env with env.example
make envfile ENVFILE=env.example
# Overwrite .env with env.example before running targetA
make envfile targetA ENVFILE=env.example
```

### Overwriting .env or not

Examples in this section use `.env` to pass environment variables to a container. The file `.env` can be overwritten when setting the environment variable `ENVFILE`. This has few advantages:

- You know the file `.env` will always be used
- Compose uses `.env` when doing [variable substitution][linkDockerComposeVarialeSubstitution]

Another option is to change the Makefile in a way to use the specified file and not overwrite the `.env` file with it.

## Check env vars in Makefile

Here is a way for checking the presence of environment variables before executing a Make target.

```makefile
# Makefile
echo: env-ENV_MESSAGE
	@docker run --rm alpine echo "$(ENV_MESSAGE)"

env-%:
	@docker run --rm -e ENV_VAR=$($*) alpine echo "Check if $* is not empty"
	@docker run --rm -e ENV_VAR=$($*) alpine sh -c '[ -z "$$ENV_VAR" ] && echo "Error: $* is empty" && exit 1 || exit 0'
```

```bash
make echo
#Check if ENV_MESSAGE is not empty
#Error: ENV_MESSAGE is empty
#make: *** [env-ENV_MESSAGE] Error 1
make echo ENV_MESSAGE=helloworld
#Check if ENV_MESSAGE is not empty
#helloworld
```

## Access env vars in command argument

```bash
# Executing the following will simply echo nothing even if ECHO is being passed.
docker run --rm -e ECHO=musketeers alpine sh -c "echo $ECHO"
# To access ECHO, either use '\'
docker run --rm -e ECHO=musketeers alpine sh -c "echo \$ECHO"
# Or use single quote
docker run --rm -e ECHO=musketeers alpine sh -c 'echo $ECHO'

# Info: Same applies with Compose.
```

## Tutorial

This simple tutorial shows how environment variables and envfiles play together.

Create the following 4 files:

```bash
# env.template
ENV_MESSAGE
```

```bash
# env.example
ENV_MESSAGE="Hello, World!"
```

```yml
# docker-compose.yml
version: '3.8'
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

```makefile
# Makefile
COMPOSE_RUN_ALPINE = docker-compose run alpine
ENVFILE ?= env.template

envfile:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) cp $(ENVFILE) .env

showMessage:
	$(COMPOSE_RUN_ALPINE) sh -c '\
		echo "# cat .env"; \
		cat .env; \
		echo "# env | grep ENV_MESSAGE"; \
		env | grep ENV_MESSAGE || true'

prune:
	ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE) rm -f .env
	ENVFILE=$(ENVFILE) docker compose down --remove-orphans
```

Then run the commands:

```bash
unset ENV_MESSAGE
make prune

make showMessage
#Failed to load .env: no such file or directory

# Create .env based on env.templates
make envfile
make showMessage
## cat .env
#ENV_MESSAGE
# env | grep ENV_MESSAGE
#

export ENV_MESSAGE="Hello!"
make showMessage
## cat .env
#ENV_MESSAGE
## env | grep ENV_MESSAGE
#ENV_MESSAGE=Hello!

# Create .env file based on env.example.
# Keep in mind ENV_MESSAGE is still set to "Hello!"
make envfile ENVFILE=env.example
make showMessage
## cat .env
#ENV_MESSAGE="Hello, World!"
## env | grep ENV_MESSAGE
#ENV_MESSAGE=Hello, World!

make prune
unset ENV_MESSAGE
```

Questions:

1. Why does command `make showMessage` fail if file `.env` is not present?
1. Why don't commands `make prune` and `make envfile` fail when file `.env` is not present?
1. What would be the main reason to use `ENVFILE=$(ENVFILE) $(COMPOSE_RUN_ALPINE)` in targets `envfile` and `prune` but not in target `showMessage`? _Hint: Do they need to have values from file `.env` for their task?_
1. Why is `ENV_MESSAGE` in the last `make showMessage` set to `Hello, World!` while it was set to `Hello!` before?



[linkSectionTutorial]: #tutorial
[linkSectionWithMakeAndCompose]: #with-make-and-compose
[linkSectionCreateEnvfile]: #create-envfile
[linkCICDAndEnvFile]: #ci-cd-pipeline

[link12factor]: https://12factor.net
[link12factorConfig]: https://12factor.net/config
[linkDockerEnvfile]: https://docs.docker.com/compose/env-file/
[linkDockerComposeVarialeSubstitution]: https://docs.docker.com/compose/compose-file/#variable-substitution
[linkGitHubActionsEnvVars]: https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
