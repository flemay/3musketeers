
# 3 Musketeers

[![Build Status][linkGitHubActionsProjectBadge]][linkGitHubActionsProject]
[![Netlify Status][linkNetlifyProjectBadge]][linkNetlifyProject]
[![License][linkLicenseBadge]][linkLicense]

<p align="center"><img src="docs/.vuepress/public/img/hero.jpg" width="300"></p>

The 3 Musketeers is a pattern for developing software in a repeatable and consistent manner. It leverages Make as an orchestration tool to test, build, run, and deploy applications using Docker and Docker Compose. The Make and Docker/Compose commands for each application are maintained as part of the application’s source code and are invoked in the same way whether run locally or on a CI/CD server.

![pattern-overview][linkPatternOverview]

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
# Update .env file to set VUEPRESS_HOST=node_dev
# install dependencies
$ make deps
# start vuepress server in a container for local development
$ make startDev
# access the website in your browser at http://localhost:8080/
# in a different shell session
$ make lint
$ make test
$ make clean
```

### Testing

```bash
$ make envfile ENVFILE=env.example
$ make deps
$ make lint
# start vuepress in a container in the background
$ make start
$ make test
$ make clean

# See targets `all`, and `ciTest`
```

### Deployment

```bash
# create a .env that sets environment variables for production. For instance
$ make envfile ENVFILE=.env.production
# building the static website
$ make build
# deploy the website to Netlify
$ make deploy

# See target `ciDeploy`
```

## Contributing

Thanks goes to these wonderful [people][linkContributors].

The 3 Musketeers is an open source project and contributions are greatly appreciated.

Please visit https://3musketeers.io/about/contributing.html for more information.

## Credits

- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)
- [VuePress](https://vuepress.vuejs.org/)
- [Favicon Generator](https://realfavicongenerator.net/)
- [draw.io](https://www.draw.io/)
- [Netlify](https://www.netlify.com/)
  - [Deployment badges](https://www.netlify.com/blog/2019/01/29/sharing-the-love-with-netlify-deployment-badges/)
  - [CLI deploy command](https://cli.netlify.com/commands/deploy)
- [GitHub Actions](https://github.com/features/actions)
  - [Adding a workflow status badge](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow#adding-a-workflow-status-badge-to-your-repository)
- [Using ESLint and Prettier in a TypeScript Project](https://www.robertcooper.me/using-eslint-and-prettier-in-a-typescript-project)

## License

[MIT][linkLicense]

[linkContributing]: ./docs/about/contributing.md
[linkContributors]: CONTRIBUTORS
[linkLicenseBadge]: https://img.shields.io/dub/l/vibe-d.svg
[linkLicense]: LICENSE
[linkPatternOverview]: ./docs/about/assets/diagrams-overview.svg

[link3Musketeers]: https://3musketeers.io
[linkGitHubActionsProject]: https://github.com/flemay/3musketeers/actions
[linkGitHubActionsProjectBadge]: https://github.com/flemay/3musketeers/workflows/Deploy/badge.svg
[linkNetlifyProject]: https://app.netlify.com/sites/wizardly-khorana-16f9c6/deploys
[linkNetlifyProjectBadge]: https://api.netlify.com/api/v1/badges/f1862de7-2548-42c8-84e2-fb7dfae6bff8/deploy-status
