<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Tutorial: One shell script file](#tutorial-one-shell-script-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Tutorial: One shell script file

It may happen that you want to use a singular shell script file that contains the _targets. With the following, you can call the _targets like this `scripts/make.sh _test _clean`

```bash
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
