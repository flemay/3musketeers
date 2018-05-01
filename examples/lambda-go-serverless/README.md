# Lambda Go Serverless Example

This example illustrates how to use the 3 Musketeers to test and build a very simple [AWS Lambda in Go](https://github.com/aws/aws-lambda-go), and deploy it to AWS using the [Serverless Framework](https://serverless.com).

The Lambda simply returns the value of the environment variable `ECHO_MESSAGE` on a `GET /echo` request.

## Prerequisites

Read [3 Musketeers README](https://github.com/flemay/3musketeers/blob/master/README.md).

## Usage

```bash
# clone the repo
$ git clone https://github.com/flemay/3musketeers.git
$ cd 3musketeers/examples/lambda-go-serverless
# create .env file based on envvars.yml with example values
$ make envfileExample
# install deps
$ make deps
# test
$ make test
# compile the go function and create package for serverless
$ make build pack
# deploy to aws
$ make deploy
# you should see something like:
#   endpoints:
#     GET - https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/echo
# request https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/echo
$ make echo
# "Thank you for using the 3 Musketeers!"
# remove the aws stack (api gateway, lambda)
$ make remove
# clean your folder and docker
$ make clean
```