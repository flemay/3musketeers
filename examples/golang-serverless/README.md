# Golang Serverless Example

A Golang Serverless application using The Three Musketeers.

## Prerequisites

- Docker
- Docker Compose
- AWS credentials in ~/.aws or environment variables
  > Environment variables can be defined inside your shell session using `export VAR=value` or setting them in .env file. See `.env.template` for more information.

## Installation

### With Serverless

    $ serverless install -u https://github.com/flemay/the-three-musketeers/tree/master/examples/golang-serverless -n your-project

### With Docker

    $ docker run --rm -v ${PWD}:/opt/app amaysim/serverless:1.23.0 serverless install -u https://github.com/flemay/the-three-musketeers/tree/master/examples/golang-serverless -n your-project

### With git

    $ git clone https://github.com/flemay/the-three-musketeers.git
    $ cp -r the-three-musketeers/tree/master/examples/golang-serverless/ your-project
    $ rm -fr the-three-musketeers/tree/master/examples/golang-serverless/
## Usage

```bash
# create .env file based on .env.example
$ make dotenv DOTENV=.env.example
# test
$ make test
# test/build the serverless package
$ make build
# deploy to aws
$ make deploy
# you should see something like:
#   endpoints:
#     GET - https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/greet
$ curl https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/greet
# {"message":"\"The Three Musketeers welcome you!\""}

# let's see the logs with serverless
$ make shellServerless
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