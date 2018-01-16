# Golang Serverless Example

A Golang Serverless application using The 3 Musketeers.

The [Go](https://golang.org) application is a very simple API that returns a greeting message as a JSON response to a GET request. [Serverless Framework](https://serverless.com) is being used to deploy the application to AWS which will create an API Gateway and a Lambda.

## Prerequisites

- Docker
- Docker Compose
- AWS credentials in ~/.aws or environment variables

## Usage

```bash
# clone the repo
$ git clone https://github.com/flemay/3musketeers.git
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
#     GET - https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/greet
$ curl https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/greet
# {"message":"\"The Three Musketeers welcome you!\""}

# let's see the logs with serverless
$ make shell
$> serverless logs -f greet
# START RequestId: 9d64b89d-b008-11e7-9c29-95aa773b2554 Version: $LATEST
# GREETING_MESSAGE is: "The Three Musketeers welcome you!"
# END RequestId: 9d64b89d-b008-11e7-9c29-95aa773b2554
#REPORT RequestId: 9d64b89d-b008-11e7-9c29-95aa773b2554  Duration: 1.05 ms       Billed Duration: 100 ms         Memory Size: 1024 MB    Max Memory Used: 23 MB
$> exit

# remove the aws stack (api gateway, lambda)
$ make remove
# clean your folder
$ make _clean
```