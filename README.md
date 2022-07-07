
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

This repository is the [3musketeers.io][link3Musketeers] website. This section explains how to develop, test, and deploy it using the 3 Musketeers.

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

### Visual elements

- 3 Musketeers logo
    - Created by Frederic Lemay with Procreate and Vectornator
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
    - According to [artegence article][linkArtegenceArticle], the ideal image that works on different social platform
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
- [VitePress](https://vitepress.vuejs.org/)
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

[linkFaviconio]: https://favicon.io
[linkDrawIO]: https://www.draw.io/
[linkArtegenceArticle]: https://artegence.com/blog/social-media-tags-guide-part-2-preparing-a-perfect-image-for-the-ogimage-tag/
