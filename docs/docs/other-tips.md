# Other tips

## Accessing host's localhost

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
