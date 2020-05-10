<p align="center"><img src="docs/.vuepress/public/img/hero.jpg" width="300"></p>

[![Build Status][linkGitHubActionsProjectBadge]][linkGitHubActionsProject]
[![Netlify Status][linkNetlifyProjectBadge]][linkNetlifyProject]
[![License](https://img.shields.io/dub/l/vibe-d.svg)][linkLicense]
[![All Contributors](https://img.shields.io/badge/all_contributors-8-orange.svg?style=flat-square)](#contributors)

# 3 Musketeers

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

## Contributors

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/flemay"><img src="https://avatars1.githubusercontent.com/u/461102?v=4" width="100px;" alt=""/><br /><sub><b>Frederic Lemay</b></sub></a><br /><a href="#blog-flemay" title="Blogposts">📝</a> <a href="https://github.com/flemay/3musketeers/commits?author=flemay" title="Code">💻</a> <a href="https://github.com/flemay/3musketeers/commits?author=flemay" title="Documentation">📖</a> <a href="#design-flemay" title="Design">🎨</a> <a href="#example-flemay" title="Examples">💡</a> <a href="#infra-flemay" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-flemay" title="Maintenance">🚧</a> <a href="#business-flemay" title="Business development">💼</a></td>
    <td align="center"><a href="https://github.com/yunspace"><img src="https://avatars2.githubusercontent.com/u/218128?v=4" width="100px;" alt=""/><br /><sub><b>Yun Zhi Lin</b></sub></a><br /><a href="#question-yunspace" title="Answering Questions">💬</a> <a href="#example-yunspace" title="Examples">💡</a> <a href="#talk-yunspace" title="Talks">📢</a> <a href="#business-yunspace" title="Business development">💼</a></td>
    <td align="center"><a href="https://github.com/adenot"><img src="https://avatars2.githubusercontent.com/u/1277170?v=4" width="100px;" alt=""/><br /><sub><b>Allan Denot</b></sub></a><br /><a href="#question-adenot" title="Answering Questions">💬</a> <a href="#business-adenot" title="Business development">💼</a></td>
    <td align="center"><a href="https://github.com/aarongorka"><img src="https://avatars1.githubusercontent.com/u/22756133?v=4" width="100px;" alt=""/><br /><sub><b>aarongorka</b></sub></a><br /><a href="https://github.com/flemay/3musketeers/commits?author=aarongorka" title="Code">💻</a> <a href="#example-aarongorka" title="Examples">💡</a> <a href="#talk-aarongorka" title="Talks">📢</a> <a href="#business-aarongorka" title="Business development">💼</a></td>
    <td align="center"><a href="https://github.com/kaleworsley"><img src="https://avatars3.githubusercontent.com/u/164566?v=4" width="100px;" alt=""/><br /><sub><b>Kale Worsley</b></sub></a><br /><a href="https://github.com/flemay/3musketeers/commits?author=kaleworsley" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/LukePeterson"><img src="https://avatars3.githubusercontent.com/u/7110561?v=4" width="100px;" alt=""/><br /><sub><b>Luke Peterson</b></sub></a><br /><a href="https://github.com/flemay/3musketeers/commits?author=LukePeterson" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/fixl"><img src="https://avatars3.githubusercontent.com/u/480719?v=4" width="100px;" alt=""/><br /><sub><b>Stefan Fuchs</b></sub></a><br /><a href="https://github.com/flemay/3musketeers/commits?author=fixl" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/robin-sim"><img src="https://avatars0.githubusercontent.com/u/50123709?v=4" width="100px;" alt=""/><br /><sub><b>robin-sim</b></sub></a><br /><a href="https://github.com/flemay/3musketeers/commits?author=robin-sim" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind are welcome! More information can be found in [contributing.md][linkContributing].

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

This project uses the following license: [MIT][linkLicense]

[linkPatternOverview]: ./docs/about/assets/diagrams-overview.svg
[linkLicense]: LICENSE
[linkContributing]: ./docs/about/contributing.md

[link3Musketeers]: https://3musketeers.io
[linkGitHubActionsProjectBadge]: https://github.com/flemay/3musketeers/workflows/Deploy/badge.svg
[linkGitHubActionsProject]: https://github.com/flemay/3musketeers/actions
[linkNetlifyProjectBadge]: https://api.netlify.com/api/v1/badges/f1862de7-2548-42c8-84e2-fb7dfae6bff8/deploy-status
[linkNetlifyProject]: https://app.netlify.com/sites/wizardly-khorana-16f9c6/deploys