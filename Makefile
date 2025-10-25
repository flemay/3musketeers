noTargetGuard:
	@echo "Choose a target"
	exit 1

COMPOSE_BUILD_BASE = docker compose build base
COMPOSE_RUN_CI = docker compose run --rm ci
COMPOSE_UP_CI = docker compose up ci -d
COMPOSE_RUN_DEV = docker compose run --service-ports --rm dev
COMPOSE_UP_DEV = docker compose up dev

ENVFILE ?= env.template
ASTRO_URL ?= http://ci:4321

envfile:
	cp -f $(ENVFILE) .env

# deps creates the base image used by other compose services
# It installs dependencies
# It copies deps from Docker volumes to the host. This is handy for auto-completion from IDE among other things.
# TODO: I could potentially look into [dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)
deps:
	$(COMPOSE_BUILD_BASE)
	$(COMPOSE_RUN_CI) deno task install
	rm -fr node_modules vendor
	docker compose create ci
	docker compose cp ci:/opt/app/node_modules .
	docker compose cp ci:/opt/app/vendor .
	docker compose rm -f ci

fmt \
check \
build \
deploy:
	$(COMPOSE_RUN_CI) deno task $@

dev:
	COMPOSE_COMMAND="deno task $@" $(COMPOSE_UP_DEV)

# TODO:
# - Instead of `sleep` Could potentially look at compose service health_check
# - https://docs.docker.com/reference/compose-file/services/#healthcheck
preview:
	$(info Target `preview` will sleep 5 seconds to make sure the server is up)
	COMPOSE_COMMAND="deno task preview" $(COMPOSE_UP_CI)
	$(COMPOSE_RUN_CI) sleep 5

previewDev:
	COMPOSE_COMMAND="deno task preview" $(COMPOSE_UP_DEV)

# testPreview test against a running preview in ci container
# If preview is running in dev container, run the following:
#  `make testPreview ASTRO_URL=http://dev:4321
testPreview:
	$(COMPOSE_RUN_CI) make _testPreview ASTRO_URL=$(ASTRO_URL)

_testPreview:
	echo "Test home page"
	curl $(ASTRO_URL) | grep "Get started" > /dev/null
	echo "Test Getting started"
	curl $(ASTRO_URL)/guides/getting-started/ | grep "Getting Started" > /dev/null

# clean removes everything that has been created
# It also deletes the deps folders from the host (instead of container) because they were copied from the volumes with `docker compose cp`
# There is no need to call `deno clean` as `"vendor": true` is used in `deno.jsonc`
clean:
	$(COMPOSE_RUN_CI) make _clean
	docker compose down --rmi "all" --remove-orphans --volumes
	rm -fr .env node_modules vendor

# Deleting node_modules and vendor folder will fail: `rm: cannot remove 'node_modules': Device or resource busy`. This is because both folders are part of a Docker data volume
# Moreover, there is no need to delete node_modules and vendor from within the container as the date will get deleted with `docker compose down`
_clean:
	rm -fr dist

shell:
	$(COMPOSE_RUN_CI) bash

shellDev:
	$(COMPOSE_RUN_DEV) bash
