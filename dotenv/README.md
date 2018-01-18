# .env

Tutorial showing how `.env` file works with Docker and Docker Compose.

## Prerequisites

- see [3 Musketeers README](https://github.com/flemay/3musketeers/blob/master/README.md)

## Tutorial

```bash
# Let's go inside a container.
$ make shell
# See the new .env file?
$ ls -la
$ cat .env
# Let's look at the environment variable ECHO_MESSAGE
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
$ export ECHO_MESSAGE="Hello World"
$ make shell
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
$ make shell DOTENV=.env.example
# What happened to .env file?
$ cat .env
$ env | grep ECHO_MESSAGE
# What's the value of ECHO_MESSAGE? Why isn't "Hello World"?
$ exit
# Clean the work directory
$ make clean
# Let's create .env from .env.template
$ make .env
# Pay attention to the output
# Let's do it again
$ make .env
# Any difference? What would happened if you modify values in the .env and rerun the command?
# Any difference in the Makefile for targets dotenv and .env? (.PHONY)

# Create a .env file based on the .env.example
$ make dotenv DOTENV=.env.example
# Then use "make shell" without specifying DOTENV
$ make shell
# In practice, you could create a file like .env.dev with the config of your dev environment and use that file to manually deploy/delete/etc your app

# Clean your current repository
$ make clean
```