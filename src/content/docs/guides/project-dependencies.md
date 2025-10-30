---
title: Project Dependencies
sidebar:
  order: 6
---

Dependencies play a major role when comes time to test, build, and deploy a
project. A project can have many dependencies such as programing languages,
third party packages, databases, etc. This section covers some approaches to
handle them with the 3 Musketeers.

:::tip

It is common for a project to combine different approaches. For instance, a
project may have a local Docker image for some dependencies and use an official
database image.

:::

## Official Docker images

This approach relies on official Docker images to manage dependencies. For
instance, a NodeJS project may use the official NodeJS Docker image to install
the node modules, run and test the application. Usually third party packages
will be shared with the host and containers. The main benefit of this approach
is that there is no need to maintain any Docker image.

```yaml title="compose.yml"
services:
  node:
    image: node
```

## Custom Docker images

Official images may not always solve project's dependency requirements and if
other projects share the same requirements, then custom Docker images may be a
good fit. The images are built by the organization, and deployed to a Docker
registry. From a project perspective, it is the same as using official Docker
images except, this time, the organization is responsible of maintaining them.

```yaml title="compose.yml"
services:
  theservice:
    image: theorganisation/theimage
```

## Dev container

If a project has specific dependency requirements, then creating (and
maintaining) custom Docker images may be overkill. Instead, the project could
have a Dockerfile that encapsulates the dependencies. This approach requires the
image to be built locally before use.

```dockerfile title="Dockerfile"
FROM alpine:latest
RUN apk --update add bash curl nodejs npm git \
  && rm -rf /var/cache/apk/*
# install node modules
RUN npm install -g \
    postcss-cli \
    autoprefixer \
# ...
```

```yaml title="compose.yml"
services:
  devcontainer:
    build: .
# ...
```

### Share Dev container between services

There are situations where having multiple services sharing the same image is
useful. For instance, there could be a base service that does not expose any
port and another service that does. The base image would be used in CI without
any port collision and the other one used locally.

```yaml title="compose.yml"
services:
  devcontainer: &devcontainer
    build: .
    image: localhost:5000/myproject-devcontainer
    pull_policy: never

  devcontainer-withports:
    <<: *devcontainer
    ports:
      - "127.0.0.1:3000:3000"
```

In the snippet above, `devcontainer` includes the combination of
[`build`, `image` and `pull_policy`][linkComposeUsingBuildAndImage] to direct
`Compose` to build the image `localhost:5000/myproject-devcontainer` if it is
not cached already. The reason why the name is specified is for service
`devcontainer-withports` to use the same image. By default, if `image` is
omitted, `Compose` would build 2 images: `myproject-devcontainer` and
`myproject-devcontainer-withports`.

[Fragment][linkComposeFragments] is used to repeat the configuration of service
`devcontainer` in service `devcontainer-withports`.

Lastly, the image name contains `localhost:5000/` to prevent from pushing the
image to a different Docker registry by mistake. With the command
`docker compose push devcontainer`, `Compose` will attempt to push the image
`localhost:5000/myproject-devcontainer` and fail unless there is a registry
service running locally.

## Share dependencies with host or not

All the approaches discussed above can share third party dependencies with the
host, usually by mounting a host directory to a Docker container and letting the
container install the dependencies. An example would be like the 3 Musketeers
website where a NodeJS container installs the packages and the `node_modules`
folder is shared with the host. This is useful when developing as IDEs can
provide intellisense (autocomplete). The dependencies can also be bundled and
passed along the pipeline stages which is usually faster that re-installing
them.

Installing the dependencies when building a Docker image is another viable
option especially if intellisense is not needed, or if the pipeline is basically
one stage.

## One or many Docker images

Usually, using official images, which tend to follow the single responsibility
principle, is preferable as those images' maintenance is already taken care of.

However, as stated before, they do not solve all problems and using a single
custom Docker image may make the project development simpler. It is not uncommon
for a project to rely on both official and custom images.

[linkComposeFragments]: https://docs.docker.com/reference/compose-file/build/#using-build-and-image
[linkComposeUsingBuildAndImage]: https://docs.docker.com/reference/compose-file/fragments/
