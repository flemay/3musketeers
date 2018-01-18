# Golang Serverless Example

A Golang Serverless application using The 3 Musketeers.

The [Go](https://golang.org) application is a very simple API that returns a message to a GET echo request. [Serverless Framework](https://serverless.com) is being used to deploy the application to AWS which will create an API Gateway and a Lambda.

## Prerequisites

- Docker
- Docker Compose
- AWS credentials in ~/.aws or environment variables

## Usage

```bash
# clone the repo
$ git clone https://github.com/flemay/3musketeers.git
$ cd 3musketeers/examples/golang-serverless
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
# "The Three Musketeers welcome you!"
# remove the aws stack (api gateway, lambda)
$ make remove
# clean your folder
$ make _clean
```