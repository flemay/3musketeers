# envfile

The 3 Musketeers suggests 2 ways to handle environment variables file `.env`. One is to use the files `.env.template`, and `.env.examples`. The second (and the recommended) is to use a tool [envvars](https://github.com/flemay/envvars).

## envvars

[envvars](https://github.com/flemay/envvars) is a flexible tool to describe and validate environment variables. It is the recommended way as it serves as documentation and validates that the environment variables are correctly set.

> Never include sensitive values like passwords as the file [envvars.yml](envvars.yml) is meant to be checked in.

Please refer to [envvars](https://github.com/flemay/envvars) to learn how to use the tool in depth. For a more complete implementation using envvars, see [../examples/lambda-go-serverless](../examples/lambda-go-serverless/README.md)

## .env.template, and .env.example

> This was the way before envvars was born.

[.env.template](.env.template) contains names of all environment variables the application and pipeline use. No values are set here. `.env.template` is meant to serve as a template to `.env`. If there is no `.env` in the directory and `ENVFILE` is not specified, Make will create a `.env` file with `.env.template`.

[.env.example](.env.example) defines values so that it can be used straight away with Make like `$ make test ENVFILE=.env.example`. It also gives an example of values that is being used in the project.

> Never include sensitive values like passwords as this file is meant to be checked in.

## Bottom line

Bottom line is that `.env` is a very important file that can be managed in different ways.

With the 3 Musketeers, `.env` is created automatically which helps automating the CI pipeline.

In a day to day development process, you could create a file like `.env.dev` with the config of your dev environment and copy the content of it into `.env` so that you can manually deploy/delete/etc your app for testing. This allows you to not loose accidentally the values if `.env` was to get replaced or the need to set all the environment variables on your machine.

# Tutorial

This Tutorial shows how `.env` file works with Docker and Docker Compose.

## Prerequisites

- see [3 Musketeers README](../README.md)

## Step by Step using envvars

This section uses envvars tool and the environment variable is declared in the file [envvars.yml](envvars.yml).

```bash
# Let's clean first
$ make clean

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
# Any change to .env?
$ cat .env
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
# Create a .env file with the example value from envvars.yml
$ make envfileExample
$ make shell
# What happened to .env file?
$ cat .env
$ env | grep ECHO_MESSAGE
# What's the value of ECHO_MESSAGE? Why isn't "Hello World"?
$ exit
# Clean the work directory
$ make clean
# Let's create explicitly .env
$ make .env
# Pay attention to the output
# Let's do it again
$ make .env
# Any difference? What would happened if you modify values in the .env and rerun the command?
# Any difference in the Makefile for targets envfileExample and .env? (.PHONY)

# Clean your current repository
$ make clean
```

## Step by Step using example/template

This section shows the way `.env` was managed before the tool envvars was born. The Make commands are inside [Makefile.env.mk](Makefile.env.mk) and will be refered in this step by step.

```bash
# Let's clean first
$ make -f Makefile.env.mk clean

# Let's go inside a container.
$ make -f Makefile.env.mk shell
# See the new .env file?
$ ls -la
$ cat .env
# Let's look at the environment variable ECHO_MESSAGE
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
$ export ECHO_MESSAGE="Hello World"
$ make -f Makefile.env.mk shell
# Any change to .env?
$ cat .env
$ env | grep ECHO_MESSAGE
# What is the value of ECHO_MESSAGE?
$ exit
$ make -f Makefile.env.mk shell ENVFILE=.env.example
# What happened to .env file?
$ cat .env
$ env | grep ECHO_MESSAGE
# What's the value of ECHO_MESSAGE? Why isn't "Hello World"?
$ exit
# Clean the work directory
$ make -f Makefile.env.mk clean
# Let's create .env from .env.template
$ make -f Makefile.env.mk .env
# Pay attention to the output
# Let's do it again
$ make -f Makefile.env.mk .env
# Any difference? What would happened if you modify values in the .env and rerun the command?
# Any difference in the Makefile for targets envfile and .env? (.PHONY)

# Create a .env file based on the .env.example
$ make -f Makefile.env.mk envfile ENVFILE=.env.example
# Then use "make -f Makefile.env.mk shell" without specifying ENVFILE
$ make -f Makefile.env.mk shell

# Clean your current repository
$ make -f Makefile.env.mk clean