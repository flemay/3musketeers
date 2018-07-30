<p align="center"><img src="assets/img/logo.jpg" width="300"></p>

[![Build Status](https://travis-ci.org/flemay/3musketeers.svg?branch=master)](https://travis-ci.org/flemay/3musketeers)
[![License](https://img.shields.io/dub/l/vibe-d.svg)](LICENSE)

# 3 Musketeers

Test, build, and deploy your apps from anywhere, the same way.

The 3 Musketeers is a pattern for developing software in a repeatable and consistent manner. It leverages Make as an orchestration tool to test, build, run, and deploy applications using Docker and Docker Compose. The Make and Docker/Compose commands for each application are maintained as part of the application’s source code and are invoked in the same way whether run locally or on a CI/CD server.

For more information, visit [3musketeers.io][].

## Usage

This repository is the [3musketeers.io][] website. This section explains the usage on how to develop and deploy it.

```bash
# create a .env file
$ make envfile ENVFILE=.env.example
# create docker image for development
$ make deps
# starting hugo server for local development
$ make server

# create a .env that sets environment variables for production. For instance
$ make envfile ENVFILE=.env.production
# building the static website
$ make build
# deploy the website to Netlify
$ make deploy
```

[3musketeers.io]: https://3musketeers.io
