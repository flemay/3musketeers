# Netlify

Some notes as a backup for how 3musketeers deployment to Netlify was done. It was deployed to 3musketeersdev.netlify.app.

## README.md

### Prerequisites

- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)
- [Netlify](https://netlify.com) account
- [Netlify personal access token](https://app.netlify.com/user/applications)

### Deployment

The 3 Musketeers website is deployed to Netlify. This section shows how to create site, deploy, and delete using [Netlify CLI][linkNetlifyCLI]. This is handy for previewing new changes.

#### Create a new site

This section creates a new empty Netlify site. Ensure the `.env` file contains the access token.

```bash
# All the following commands will be run inside a container
make shell

# Disable telemetry (optional)
yarn run netlify --telemetry-disable

# Create new Netlify blank site
yarn run netlify sites:create --disable-linking
# Answer the questions regarding the team and site name
# Site name can be something like 3musketeers-preview-{random 5 digit numbers}
Site Created

Admin URL: https://app.netlify.com/sites/site-name
URL:       https://site-name.netlify.app
Site ID:   site-id

# You can always get back that information
yarn run netlify sites:list

# Copy the ID to .env

# Exit the container
exit
```

#### Deploy

This section deploys the website to an existing netlify site. Ensure the `.env` file contains the right site ID and access token.

```bash
# Build the website
make build
# Deploy to netlify
make deploy
# Test the website
curl https://site-name.netlify.app
# Clean up directory
make prune
```

#### Delete

This section deletes a netlify site. Ensure the `.env` file contains the right site ID and access token.

```bash
# All the following commands will be run inside a container
make shell
# Disable telemetry (optional)
yarn run netlify --telemetry-disable
# Delete the site (optional)
yarn run netlify sites:delete
# Exit the container
exit
```

### CI/CD

[GitHub Actions][linkGitHubActions] is used to test PRs and deploy changes made to `main` branch to Netlify.

- A dedicated Netlify personal access token has been created for Github Actions
- Environment variables required for deploying to Netlify are set as [secrets for GitHub Actions][linkGitHubActionsSecrets]
- The GitHub Actions workflows follow the 3 Musketeers pattern so it is a good real life example

[linkNetlify]: https://netlify.com
[linkNetlifyProject]: https://app.netlify.com/sites/wizardly-khorana-16f9c6/deploys
[linkNetlifyProjectBadge]: https://img.shields.io/netlify/f1862de7-2548-42c8-84e2-fb7dfae6bff8?label=Deploy&logo=netlify&style=for-the-badge
[linkNetlifyCLI]: https://cli.netlify.com/commands/
[linkNetlifyDeploymentBadge]: https://www.netlify.com/blog/2019/01/29/sharing-the-love-with-netlify-deployment-badges/

## env.template

```bash
# NETLIFY_AUTH_TOKEN is the personal access token in the applications in Netlify user settings
# NETLIFY_SITE_ID is the API ID found in the Netlify site details
NETLIFY_AUTH_TOKEN
NETLIFY_SITE_ID
```

## package.json

```json
    "netlify-cli": "*",
```

## Makefile

```Makefile
deploy:
	$(COMPOSE_RUN_NODE) make _deploy
_deploy:
	npx netlify --telemetry-disable
	npx netlify deploy --dir=docs/.vitepress/dist --prod
```
