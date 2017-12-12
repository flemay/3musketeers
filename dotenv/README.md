# .env

Tutorial showing how `.env` file works with Docker and Docker Compose.

## Prerequisites

- [Docker](https://docs.docker.com/engine/installation/) (_Docker on Mac/Windows is recommended if you do not use Unix_)
- [Docker Compose](https://docs.docker.com/compose/install/) (_which comes bundled with Docker on Mac/Windows_)
- Make (_which is native to Mac/Unix_)

## Tutorial

```bash
# Clean the work directory
$ make _clean
# Let's go inside a container.
$ make shell
# See the new .env file?
$ ls -la
$ cat .env
# Let's look at the environment variable GREETING_MESSAGE
$ env | grep GREETING_MESSAGE
# What is the value of ENV?
$ exit
$ export GREETING_MESSAGE="Hello World"
$ make shell
$ env | grep GREETING_MESSAGE
# Is the value "Hello World"?
$ exit
$ make shell DOTENV=.env.example
# What happened to .env file?
$ cat .env
$ env | grep GREETING_MESSAGE
# What's the value of GREETING_MESSAGE? Why isn't "Hello World"?
$ exit
# Clean the work directory
$ make _clean
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
```