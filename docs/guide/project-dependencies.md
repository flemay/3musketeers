# Project dependencies

Dependencies play a major role when comes time to test, build, and deploy a project. A project can have many dependencies such as programing languages, third party packages, databases, etc. This section covers some approaches to handle them with the 3 Musketeers.

::: tip
It is not uncommon for a project to combine the approaches. For instance, a project may have a local Docker images for some dependencies and use an official database image.
:::

## Official Docker images

This approach relies on official Docker images to manage dependencies. For instance, a NodeJS project may use the official NodeJS Docker image to install the node modules, run and test the application. Usually third party packages will be shared with the host and containers. The main benefit of this approach is that there is no need to maintain any Docker image.

Example from The [3 Musketeers repository&#8599;](https://github.com/flemay/3musketeers):

```yaml
# docker-compose.yml
version: '3.7'
services:
  node:
    image: node
# ...
```

## Custom Docker images

Official images may not always solve project's dependency requirements and if other projects share the same requirements, then custom Docker images may be a good fit. The images are built by the organization, and deployed to a Docker registry. From a project perspective, it is the same as using official Docker images except, this time, the organization is responsible of maintaining them.

```yaml
# docker-compose.yml
version: '3.7'
services:
  theservice:
    image: theorganisation/theimage
```

## Local custom Docker images

If a project has specific dependency requirements, then creating (and maintaining) custom Docker images may be overkill. Instead, the project could have a Dockerfile that encapsulates the dependencies. This approach requires the image to be built locally before use.

```docker
FROM alpine:latest
RUN apk --update add bash curl nodejs npm git \
  && rm -rf /var/cache/apk/*
# install Hugo
# ...
# install node modules
RUN npm install -g \
    postcss-cli \
    autoprefixer \
# ...
```

```yaml
# docker-compose.yml
version: '3.7'
services:
  mycontainer:
    build: .
    image: flemay/myimage:local
# ...
```

## Share dependencies with host or not

All the approaches discussed above can share third party dependencies with the host, usually by mounting a host directory to a Docker container and letting the container install the dependencies. An example would be like the 3 Musketeers website where a NodeJS container installs the packages and the `node_modules` folder is shared with the host. This is useful when developing as IDEs can provide autocomplete. The dependencies can also be bundled and passed along the pipeline stages which is usually faster that re-installing them.

Installing the dependencies when building a Docker image is another viable option especially if autocomplete is not needed, or if the pipeline is basically one stage.

## One or many Docker images

Usually, using official images, which tend to follow the single responsibility principle, is preferable as those images' maintenance is already taken care of.

However, as stated before, they do not solve all problems and using a single custom Docker image may make the project development simpler. It is not uncommon for a project to rely on both official and custom images.

