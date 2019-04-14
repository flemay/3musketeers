# Patterns

In a nutshell, a user calls a Make target which then delegates the Task to be executed in a Container to Docker or Compose.

![pattern-overview](./assets/diagrams-pattern-overview.svg)

This section covers the following patterns:

[[toc]]

::: tip
All examples in this section works out of the box as long as Docker, Compose, and Make are installed.
:::

## Make

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
	echo 'Hello World!'
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
	docker-compose run --rm alpine sh -c 'echo Hello World!'
```

```bash
$ make echo
```

## Shell file

Make calls Compose which executes a shell/bash command inside a Docker container. Also, an example of a shell file that mimics Make can be found [here][linkOtherTips].

![pattern-shell-file](./assets/diagrams-pattern-shell-file.svg)

::: tip
This pattern is used to build and deploy this very website. See the [code][link3MusketeersGitHub].
:::

```bash
# echo.sh
#!/usr/bin/env sh
echo Hello World!
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


Languages like Python, JavaScript, Golang, Ruby, etc can be used as an alternative to shell/bash scripts. The following example uses JavaScript to echo hello world.

![pattern-language](./assets/diagrams-pattern-language.svg)

```js
// helloworld.js
console.log('Hello World');
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

There are many languages and tools out there to make task implementation easy such as Gulp and Rake. Those tools can easily be integrated to the 3 Musketeers. The following is simply a NodeJS example which echos "Hello World" by invoking npm.

![pattern-task-tool](./assets/diagrams-pattern-task-tool.svg)

```json
// package.json

{
  "name": "helloworld",
  "description": "echos Hello World!",
  "scripts": {
    "echo": "echo \"Hello World!\""
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
	docker run --rm alpine echo Hello World
```

```bash
$ make echo
```

There are situations where calling Docker is required. For instance, if you generate a `.env` file from a container and that at least one of the Compose services uses `.env` file, then using the Compose command outputs an error like the following:

```
ERROR: Couldn't find env file: /github.com/flemay/3musketeers/.env
```

[linkDocker]: docker
[linkOtherTips]: other-tips

[link3MusketeersGitHub]: https://github.com/flemay/3musketeers
