# Tutorial: One shell script file

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

