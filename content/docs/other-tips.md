---
title: Other tips
draft: false
date:
lastmod:
description: Other useful tips.
weight: 500
toc: true
---

# Other tips

## Accessing host's localhost

On Windows/Mac, accessing the host localhost is to use the url like `docker.for.mac.localhost`. This is handy because if you have an application running on `localhost:3000` locally (through container or not), then you can access it `$ curl docker.for.mac.localhost:3000`.

## Access environment variables in command argument

 ```bash
 # writing something like the following
 $ docker run --rm -e ECHO=musketeers alpine sh -c "echo $ECHO"
 # will simply echo nothing even if ECHO is being passed.

 # To access ECHO, either use '\'
 $ docker run --rm -e ECHO=musketeers alpine sh -c "echo \$ECHO"

 # or use single quote
 $ docker run --rm -e ECHO=musketeers alpine sh -c 'echo $ECHO'

# Same applies to Compose.
 ```

## One shell script file

It may happen to want to use a singular shell script file that contains the _targets. With the following, you can call the _targets like this `scripts/make.sh _test _clean`

```sh
# scripts/make.sh
#!/usr/bin/env sh

_test(){
  echo "_test"
}

_clean(){
  echo "_clean"
}

for target in "$@"
do
  case "$target" in
    (_test)
      _test
      ;;
    (_clean)
      _clean
      ;;
    (*)
      echo "Usage: $0 {_clean|_test}"
      exit 2
      ;;
  esac
done
```

## Waiting a service to be available

Often, there is a need to wait for a service before doing something else. For instance, waiting for a database container to be ready before running migration. The image `jwilder/dockerize` can be used.

```Makefile
dbStart:
  docker-compose up -d db
  docker-compose run --rm dockerize -wait tcp://db:3306 -timeout 60s
.PHONY: dbStart
```

## Docker development is slow

It may happen that using Docker when mounting volumes is slow on Mac and Windows. For instance, developing a rails application. An handy tool to have is [docker-sync][dockerSync]

On Mac, I found using the strategy `native_osx` to work well.

The Docker Compose file would look like the following:

```yml
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

This would work well on Windows/Mac but what about Linux? Either docker-sync is still used, which uses the native strategy and would not sync, or you use an environment variable which set the volume: `app-sync:/opt/app:nocopy` or `.:/opt/app`.

## AWS environment variables vs ~/.aws

In the [lambda example][musketeersLambdaGoServerless], `envvars.yml` contains the following optional environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, and `AWS_PROFILE`. Also, the `docker-compose.yml` mounts the volume `~/.aws`.

If you are using `~/.aws`, no need to set values and they won't be included in the Docker container. If there is a value for any of the environment variables, it will have precedence over ~/.aws when using aws cli.

[dockerSync]: http://docker-sync.io
[musketeersLambdaGoServerless]: https://gitlab.com/flemay/cookiecutter-musketeers-lambda-go-serverless/