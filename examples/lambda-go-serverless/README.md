# Lambda Go Serverless Example

This example illustrates how to use the 3 Musketeers to build, test, and deploy a [Lambda written in Go](https://github.com/aws/aws-lambda-go) using [Serverless Framework](https://serverless.com).

The [Go](https://golang.org) application is a very simple API that echos the value of the environment variable ECHO_MESSAGE on a GET request.

## Prerequisites

- see [3 Musketeers README](https://github.com/flemay/3musketeers/blob/master/README.md)

## Usage

```bash
# clone the repo
$ git clone https://github.com/flemay/3musketeers.git
$ cd 3musketeers/examples/lambda-go-serverless
# create .env file based on .env.example
$ make dotenv DOTENV=.env.example
# install deps
$ make deps
# test
$ make test
# build the serverless package
$ make build
# deploy to aws
$ make deploy
# you should see something like:
#   endpoints:
#     GET - https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/echo
$ make echo
# "Thank you for using the 3 Musketeers!"
# remove the aws stack (api gateway, lambda)
$ make remove
# clean your folder
$ make clean
```