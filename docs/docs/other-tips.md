# Other tips

## Accessing host's localhost from a container

On Windows/Mac, accessing the host localhost is to use the url like `host.docker.internal`. This is handy because if you have an application running on `localhost:3000` locally (through container or not), then you can access it `$ curl host.docker.internal:3000`.

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

It may happen that you want to use a singular shell script file that contains the _targets. With the following, you can call the _targets like this `scripts/make.sh _test _clean`

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

## AWS environment variables and ~/.aws

When using AWS, you can use environment variables. This is useful when you assume role as usually a tool like [assume-role][linkAssumeRole] would set your environment variables.

```
# .env.template
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
AWS_PROFILE
```

or share your AWS folder like the following:

```yaml
# docker-compose.yml
services:
  serverless:
    image: flemay/aws
    env_file: .env
    volumes:
      - ~/.aws:/root/.aws:Z
```

Or both can be used. In this case, environment variables will take precedence over `~/.aws` when using AWS cli.


[linkAssumeRole]: https://github.com/remind101/assume-role