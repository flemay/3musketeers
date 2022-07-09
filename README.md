
# 3 Musketeers

[![Build Status][linkGitHubActionsProjectBadge]][linkGitHubActionsProject]
[![Netlify Status][linkNetlifyProjectBadge]][linkNetlifyProject]
[![License][linkLicenseBadge]][linkLicense]

<br>
<p align="left"><img src="docs/public/img/hero-v2.svg" width="300"></p>

Test, build, and deploy your apps from anywhere, the same way!

## Overview

The 3 Musketeers is a pattern for developing software in a repeatable and consistent manner. It leverages Make as an orchestration tool to test, build, run, and deploy applications using Docker and Docker Compose. The Make and Docker/Compose commands for each application are maintained as part of the application’s source code and are invoked in the same way whether run locally or on a CI/CD server.

![pattern-overview][linkPatternOverview]

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Why?](#why)
  - [Consistency](#consistency)
  - [Control](#control)
  - [Confidence](#confidence)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Website](#website)
  - [Prerequisites](#prerequisites-1)
  - [Development](#development)
  - [Deployment](#deployment)
    - [Prerequisites](#prerequisites-2)
    - [Create a new site](#create-a-new-site)
    - [Deploy](#deploy)
    - [Delete](#delete)
  - [Visual elements](#visual-elements)
- [Contributing](#contributing)
- [References](#references)
- [Stargazers over time](#stargazers-over-time)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Why?

### Consistency

Run the same commands no matter where you are: Linux, MacOS, Windows, CI/CD tools that supports Docker like GitHub Actions, Travis CI, CircleCI, and GitLab CI.

### Control

Take control of languages, versions, and tools you need, and version source control your pipelines with your preferred VCS like GitHub and GitLab

### Confidence

Test your code and pipelines locally before your CI/CD tool runs it. Feel confident that if it works locally, it will work in your CI/CD server.

## Prerequisites

- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)

## Usage

Create the two following files:

```yaml
# file: docker-compose.yml
version: '3'
services:
  alpine:
    image: alpine
```

```makefile
# file: Makefile

# echo calls Compose to run the command "echo 'Hello, World!'" in a Docker container
echo:
	docker-compose run --rm alpine echo 'Hello, World!'
```

Then simply echo "Hello, World!" with the following command:

```bash
$ make echo
```

<br>

For more information, visit [3musketeers.io][link3Musketeers].

## Website

This repository is the [3musketeers.io][link3Musketeers] website built with [VitePress][linkVitePress]. This section explains how to develop, test, and deploy using the 3 Musketeers.

### Prerequisites

- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)

### Development

```bash
# create a .env file
$ make envfile ENVFILE=env.example
# install dependencies
$ make deps

# start vitepress server for local development
$ make dev
# wait till the message 'vite v2.5.3 dev server running at' appears
# access the website in your browser at http://localhost:8080/
# \<ctrl-c\> to stop

# build static site
$ make build

# serve static site for local development
$ make serveDev
# access the website in your browser at http://localhost:8080/
# \<ctrl-c\> to stop

# serve static website (headless)
$ make serve

# test static website
$ make test

# deploy to netlify (do not forget to set the environment variables)
$ make deploy

# clean
$ make clean

# contributing? make sure the following command runs successfully
$ make all
```

### Deployment

The 3 Musketeers website is deployed to Netlify. This section shows how to create site, deploy, and delete using [Netlify CLI](https://cli.netlify.com/commands/). This is handy when previewing new changes.

#### Prerequisites

- A [Netlify](https://netlify.com) account
- A [personal access token](https://app.netlify.com/user/applications)

#### Create a new site

This section creates a blank Netlify site. Ensure the `.env` file contains the access token.

```bash
# All the following commands will be run inside a container
$ make shell

# Disable telemetry (optional)
$ yarn run netlify --telemetry-disable

# Create new Netlify blank site
$ yarn run netlify sites:create --disable-linking
# Answer the questions regarding the team and site name
# Site name can be something like 3musketeers-preview-{random 5 digit numbers)
Site Created

Admin URL: https://app.netlify.com/sites/site-name
URL:       https://site-name.netlify.app
Site ID:   site-id

# You can always get back that information
$ yarn run netlify sites:list

# Copy the ID to .env
```

#### Deploy

This section deploys the website to an existing netlify site. Ensure the `.env` file is contains the right site ID and access token.

```bash
# Build the website
$ make build

# Deploy to netlify
$ make deploy

# Test the website
$ curl https://site-name.netlify.app
```

#### Delete

This section deletes the netlify site. Ensure the `.env` file is contains the right site ID and access token.

```bash
# All the following commands will be run inside a container
$ make shell

# Disable telemetry (optional)
$ yarn run netlify --telemetry-disable

# Delete the site (optional)
$ yarn run netlify sites:delete

# Exit the container
$ exit
```

### Visual elements

- 3 Musketeers logo
    - Created by Frederic Lemay with Procreate and Vectornator
        - Neat tools used are [offset path][linkVectornatorOffsetPath] and [mask objects][linkVectornatorMaskObjects]
    - 2048px by 2048px SVG image
    - Images are in folder `docs/public/img`
- Favicon
    - Source image is an exported png format of the logo
    - Use the website [favicon.io][linkFaviconio]
    - The generated content is in `docs/public/favicon_io`
    - File docs/public/favicon.io is a copy of the file in `docs/public/favicon_io`
        - By default, browsers searches for /favicon.io
    - HTML `link` tags have been set in file `/docs/.vitepress/config.js`
- Social media preview
    - This is for displaying preview of the website on Twitter, Facebook, GitHub, etc
    - HTML `meta` tags have been set in file `/docs/.vitepress/config.js`
    - Created a new vector image 1280x640px with the scale down logo at the center
        - The size is suggested by GitHub in General settings
    - According to [artegence article][linkArtegenceArticle], the ideal image that works on different social platforms
        - Is 1200x630px
        - Has the logo (630x630) centered
        - Use png format (very high quality and transparency)
        - Use jpg format (high quality and very good size compression)
- Diagrams
    - [draw.io][linkDrawIO] is used to generate diagrams
    - All diagrams are in the file `diagrams.drawio`

## Contributing

Thanks goes to these wonderful [people][linkContributors].

The 3 Musketeers is an open source project and contributions are greatly appreciated.

Please visit https://3musketeers.io/guide/contributing.html for more information.

## References

- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)
- [VitePress][linkVitePress]
- [Netlify](https://www.netlify.com/)
  - [Deployment badges](https://www.netlify.com/blog/2019/01/29/sharing-the-love-with-netlify-deployment-badges/)
  - [CLI deploy command](https://cli.netlify.com/commands/deploy)
- [GitHub Actions](https://github.com/features/actions)
  - [Adding a workflow status badge](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow#adding-a-workflow-status-badge-to-your-repository)
- [Vectornator](https://www.vectornator.io/)
- [favicon.io][linkFaviconio]
- [draw.io][linkDrawIO]
- [Preparing a perfect image for the og:image tag][linkArtegenceArticle]

## Stargazers over time

[![Stargazers over time][linkProjectStargazersSVG]][linkProjectStargazers]

## License

[MIT][linkLicense]


[linkContributing]: ./docs/guide/contributing.md
[linkContributors]: CONTRIBUTORS
[linkLicenseBadge]: https://img.shields.io/dub/l/vibe-d.svg
[linkLicense]: LICENSE
[linkPatternOverview]: ./docs/guide/assets/diagrams-overview.svg

[link3Musketeers]: https://3musketeers.io
[linkGitHubActionsProject]: https://github.com/flemay/3musketeers/actions
[linkGitHubActionsProjectBadge]: https://github.com/flemay/3musketeers/workflows/Deploy/badge.svg
[linkNetlifyProject]: https://app.netlify.com/sites/wizardly-khorana-16f9c6/deploys
[linkNetlifyProjectBadge]: https://api.netlify.com/api/v1/badges/f1862de7-2548-42c8-84e2-fb7dfae6bff8/deploy-status
[linkProjectStargazersSVG]: https://starchart.cc/flemay/3musketeers.svg
[linkProjectStargazers]: https://starchart.cc/flemay/3musketeers

[linkVitePress]: https://vitepress.vuejs.org/
[linkFaviconio]: https://favicon.io
[linkDrawIO]: https://www.draw.io/
[linkArtegenceArticle]: https://artegence.com/blog/social-media-tags-guide-part-2-preparing-a-perfect-image-for-the-ogimage-tag/
[linkVectornatorOffsetPath]: https://www.vectornator.io/learn/paths#how-to-create-an-offset-path
[linkVectornatorMaskObjects]: https://www.vectornator.io/learn/options#how-to-mask-objects
