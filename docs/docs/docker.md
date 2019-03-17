# Docker

This section contains some tips related to Docker.

## Accessing host's localhost from a container

On Windows/Mac, accessing the host localhost is to use the url like `host.docker.internal`. This is handy because if you have an application running on `localhost:3000` locally (through container or not), then you can access it `$ curl host.docker.internal:3000`.

## Useful Docker Images

### jwilder/dockerize

There is often a need to wait for a service to start before interacting with it. For instance, waiting for a database container to be ready before running a migration. The image `jwilder/dockerize` can be used to help with this scenario.

```makefile
dbStart:
	docker-compose up -d db
	docker-compose run --rm dockerize -wait tcp://db:3306 -timeout 60s
```

## Image without Make

One of the [patterns][linkPatterns] is to call Make from Compose. If you want to follow this pattern and your image does not have `make`, here are some solutions to address that.

### Use a different image

Often image publishers offer different versions of the application/product. For instance [golang][linkGolang] has an image based on `alpine` which does not have `make`. It also has an image based on `stretch` which does.

```bash
$ docker run --rm golang:alpine make
# "exec: \"make\": executable file not found
$ docker run --rm golang:stretch make
# make: *** No targets specified and no makefile found
```

### Use Musketeers Docker image

If you only want to call `make` with common shell commands, or want to use `git` and `zip`, then the lightweight [Musketeers Docker][linkDockerMusketeersRepo] image is for you.

### Install Make on the fly

Whenever a command runs another command it installs `make` and then execute `$ make _target`. Depending on how many times a command is run, this may be inefficient as it needs to download `make` every time.

```bash
$ docker run --rm golang:alpine apk add --update make && make _target
```

### Build your own image

You may want to build and maintain your own image based on the the image you wanted to use.

```dockerfile
FROM node:alpine
RUN apk add --update make
...
```

## Docker development is slow

Mounting volumes with Docker on Mac or Windows can be slow. For instance, developing a rails application. A handy tool which can help solve this problem is [docker-sync][linkDockerSync]

On Mac, using the `native_osx` strategy can also help. The Docker Compose file would look like the following:

```yaml
 yourservice:
    image: animage
    volumes:
      - app-sync:/opt/app:nocopy
...

volumes:
  # this volume is created by docker-sync. See docker-sync.yml for the config
  app-sync:
    external: true
```

This would work well on Windows/Mac but what about Linux? Either docker-sync is still used, which uses the native strategy and would not sync, or you use an environment variable which sets the volume: `app-sync:/opt/app:nocopy` or `.:/opt/app`.


[linkPatterns]: patterns

[linkDockerSync]: http://docker-sync.io
[linkGolang]: https://hub.docker.com/_/golang/
[linkDockerMusketeersRepo]: https://github.com/flemay/docker-musketeers
