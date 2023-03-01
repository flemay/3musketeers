# Environment variables

Development following [the twelve-factor app][link12factor] use the [environment variables to configure][link12factorConfig] their application.

Often there are many environment variables and having them in a `.env` file becomes handy. Docker and Compose do use [environment variables file][linkDockerEnvfile] to pass the variables to the containers.

## Env file and expectations

With the following `.env` file:

```
# make sure these env vars are not set in the system
ENV_A
ENV_B=
ENV_C=env_c
```

And the `docker-compose.yml` file:

```yaml
services:
  alpine:
    image: alpine
    env_file: .env
```

The expected results are:

```bash
$ docker run --rm --env-file=.env alpine env
ENV_B=
ENV_C=env_c
# ENV_A is not set and ENV_B is set to empty

$ docker-compose run --rm alpine env
ENV_B=
ENV_C=env_c
# Same as Docker
```

## Structure env file

Environment variables can be used at different stages of software development: build, test, deploy, and run time. The following is an example how to keep .env file structured.

```
# All
ENV

# Deploy
AWS_VPC

# Test
CODECOV_URL

# Build and deploy
BUILD_DIR

# Test and run
DB_HOST
```

## Template and example env files

`env.template` and `env.example` files provide some help when managing environment variables in a project.

::: danger ENV FILES AND SOURCE CONTROL
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

## Day-to-day development

In a day-to-day development process, you could create a file named `.env.dev` with the config of your dev environment and copy the contents of it into `.env` so that you can manually deploy/delete/etc your app for testing. This allows you to not accidentally lose the values if the `.env` file is replaced.
There are few ways to copy the contents of your file to `.env`:

- manually
- [make envfile ENVFILE=_yourfile_][linkMakeTargetsEnvfileAndDotEnv]

## Tutorial

Go to this [tutorial][linkTutorial] to learn more about environment variables with Docker and Compose.


[linkTutorial]: https://github.com/flemay/3musketeers/tree/main/tutorials/environment_variables
[linkMakeTargetsEnvfileAndDotEnv]: #make-targets-envfile-and-env
[linkCICDAndEnvFile]: #ci-cd-pipeline

[link12factor]: https://12factor.net
[link12factorConfig]: https://12factor.net/config
[linkDockerEnvfile]: https://docs.docker.com/compose/env-file/
