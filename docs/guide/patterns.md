# Patterns

In a nutshell, a user calls a Make target which then delegates the Task to be executed in a Container to Docker or Compose.

![pattern-overview](./assets/diagrams-pattern-overview.svg)

This section covers the following patterns:

[[toc]]

::: tip
A project does not need to follow only 1 pattern. For instance, a task A can use the pattern `Shell command` and task B, `Shell file`.
:::

## Make

::: info
This pattern is used to build and deploy this very website. See the [code][link3MusketeersGitHub].
:::

Make calls Compose which then calls another Make target inside a Docker container. This pattern requires the Docker image to have Make installed.

![pattern-make](./assets/diagrams-pattern-make.svg)

::: tip
There are [ways][linkDocker] to add Make to your Docker image if it does not have it.
:::

```yaml
# docker-compose.yml
version: '3'
services:
  alpine:
    image: golang
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```makefile
# Makefile
echo:
	docker-compose run --rm alpine make _echo

_echo:
	echo 'Hello, World!'
```

```bash
$ make echo
```

## Shell command

Make calls Compose which executes a shell/bash command inside a Docker container.

![pattern-shell](./assets/diagrams-pattern-shell.svg)

```yaml
# docker-compose.yml
version: '3'
services:
  alpine:
    image: alpine
```

```makefile
# Makefile
echo:
	docker-compose run --rm alpine sh -c 'echo Hello, World!'
```

```bash
$ make echo
```

## Shell file

Make calls Compose which executes a shell/bash command inside a Docker container. Also, an example of a shell file that mimics Make can be found [here][linkTutorialOneShellScript].

![pattern-shell-file](./assets/diagrams-pattern-shell-file.svg)

```bash
# echo.sh
#!/usr/bin/env sh
echo Hello, World!
```

```bash
# set executable permission
$ chmod +x echo.sh
```

```yaml
# docker-compose.yml
version: '3'
services:
  alpine:
    image: alpine
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```makefile
# Makefile
echo:
	docker-compose run --rm alpine sh echo.sh
```

```bash
$ make echo
```

## Languages


Languages like Python, JavaScript, Golang, Ruby, etc can be used as an alternative to shell/bash scripts. The following example uses JavaScript to echo 'Hello, World!'.

![pattern-language](./assets/diagrams-pattern-language.svg)

```js
// helloworld.js
console.log('Hello, World!');
```

```yaml
# docker-compose.yml
version: '3'
services:
  node:
    image: node:alpine
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```makefile
# Makefile
echo:
	docker-compose run --rm node node helloworld.js
```

```bash
$ make echo
```

## Task management tool

There are many languages and tools out there to make task implementation easy such as Gulp and Rake. Those tools can easily be integrated to the 3 Musketeers. The following is simply a NodeJS example which echos "Hello, World!" by invoking npm.

![pattern-task-tool](./assets/diagrams-pattern-task-tool.svg)

```json
// package.json

{
  "name": "helloworld",
  "description": "echos 'Hello, World!'",
  "scripts": {
    "echo": "echo 'Hello, World!'"
  },
}
```

```yaml
# docker-compose.yml
version: '3'
services:
  node:
    image: node:alpine
    volumes:
      - .:/opt/app
    working_dir: /opt/app
```

```makefile
# Makefile
echo:
	docker-compose run --rm node npm run echo
```

```bash
$ make echo
```

## Docker

Make calls directly Docker instead of Compose. Everything that is done with Compose can be done with Docker. Using Compose helps to keep the Makefile clean.

![pattern-docker](./assets/diagrams-pattern-docker.svg)

```makefile
echo:
	docker run --rm alpine echo 'Hello, World!'
```

```bash
$ make echo
```

There are situations where calling Docker is required. For instance, if you generate a `.env` file from a container and that at least one of the Compose services uses `.env` file, then using the Compose command outputs an error like the following:

```
ERROR: Couldn't find env file: /github.com/flemay/3musketeers/.env
```

More details in [Environment variables][linkEnvironmentVariables] section.

## Docker-in-Docker (DinD)

::: info DIND EXPLAINED
Jérôme Petazzoni's excellent [blog post][linkDinD] on using Docker-in-Docker outlines some of the pros and cons of doing so (and some nasty gotchas you might run into). This 3 Musketeers pattern is about "The socket solution" described in his post.
:::

So far, the patterns are for hosts (environments) that provide access to Make, Docker (and daemon), and Compose. However, there are times when the environment provided is Docker containers with no access to Make, Docker, or Compose. The 3 Musketeers can be applied by using a Docker image that provides Make, Docker (client), and Compose, such as [flemay/musketeers][linkMusketeersImage], given it has access to the Docker socket which allows Docker (client) to connect to the Docker engine.

![pattern-dind](./assets/diagrams-pattern-dind.svg)

An example is with GitLab CI. [It allows you to access Docker within a Docker container&#8599;][linkGitLabDinD]. A pipeline configuration would look like the following:

```yaml
# .gitlab-ci.yml
image: flemay/musketeers:latest
services:
  - docker:dind
variables:
  DOCKER_HOST: "tcp://docker:2375"

stages:
  - test

test:
  stage: test
  script:
    - make test
```

[linkDocker]: docker
[linkTutorialOneShellScript]: ../tutorials/one-shell-script-file
[linkEnvironmentVariables]: ../tutorials/environment-variables.html#make-targets-envfile-and-env

[linkCookiecutter]: https://gitlab.com/flemay/docker-cookiecutter
[linkMusketeersImage]: https://cloud.docker.com/u/flemay/repository/docker/flemay/musketeers
[link3MusketeersGitHub]: https://github.com/flemay/3musketeers
[linkDinD]: https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
[linkGitLabDinD]: https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
