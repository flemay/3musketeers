<p align="center"><img src="docs/.vuepress/public/img/hero.jpg" width="300"></p>

[![Build Status][linkTravisCIProjectBadge]][linkTravisCIProject]
[![Netlify Status][linkNetlifyProjectBadge]][linkNetlifyProject]
[![License](https://img.shields.io/dub/l/vibe-d.svg)][linkLicense]

# 3 Musketeers

The 3 Musketeers is a pattern for developing software in a repeatable and consistent manner. It leverages Make as an orchestration tool to test, build, run, and deploy applications using Docker and Docker Compose. The Make and Docker/Compose commands for each application are maintained as part of the application’s source code and are invoked in the same way whether run locally or on a CI/CD server.

![pattern-overview][linkPatternOverview]

## Why?

### Consistency

Run the same commands no matter where you are: Linux, MacOS, Windows, CI/CD tools that supports Docker like Travis CI, CircleCI, and GitLab CI.

### Control

Take control of languages, versions, and tools you need, and version source control your pipelines with your preferred VCS like GitHub and GitLab

### Confidence

Test your code and pipelines locally before your CI/CD tool runs it. Feel confident that if it works locally, it will work in your CI/CD server.

<br>

For more information, visit [3musketeers.io][link3Musketeers].

## Usage

This repository is the [3musketeers.io][link3Musketeers] website. This section explains the usage on how to develop and deploy it.

```bash
# Development

# create a .env file
$ make envfile ENVFILE=env.example
# Update .env file to set VUEPRESS_HOST=vuepress_dev
# install dependencies
$ make deps
# start vuepress server in a container for local development
$ make startDev
# in a different shell session
$ make lint
$ make test
$ make clean
```

```bash
# Testing

$ make envfile ENVFILE=env.example
$ make deps
$ make lint
# start vuepress in a container in the background
$ make start
$ make test
$ make clean

# See targets `all`, `travisPullRequest`
```

```bash
# Building and Deployment

# create a .env that sets environment variables for production. For instance
$ make envfile ENVFILE=.env.production
# building the static website
$ make build
# deploy the website to Netlify
$ make deploy

# See target `travisMasterChange`
```


[linkPatternOverview]: ./docs/about/assets/diagrams-overview.svg
[linkLicense]: LICENSE

[link3Musketeers]: https://3musketeers.io
[linkTravisCIProjectBadge]: https://travis-ci.org/flemay/3musketeers.svg?branch=master
[linkTravisCIProject]: https://travis-ci.org/flemay/3musketeers
[linkNetlifyProjectBadge]: https://api.netlify.com/api/v1/badges/f1862de7-2548-42c8-84e2-fb7dfae6bff8/deploy-status
[linkNetlifyProject]: https://app.netlify.com/sites/wizardly-khorana-16f9c6/deploys
