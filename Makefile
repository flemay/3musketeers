noTargetGuard:
	$(error Target is missing)

COMPOSE_PULL_BUSYBOX = docker compose pull busybox
COMPOSE_RUN_BUSYBOX = docker compose run --rm busybox
COMPOSE_BUILD_BASE = docker compose build base
# COMPOSE_RUN_CI = COMPOSE_ENVFILE=$(ENVFILE) docker compose run --rm ci
COMPOSE_RUN_CI = COMPOSE_ENVFILE=.env docker compose run --rm ci
COMPOSE_UP_CI = COMPOSE_ENVFILE=.env docker compose up ci -d
COMPOSE_RUN_DEV = COMPOSE_ENVFILE=.env docker compose run --service-ports --rm dev
COMPOSE_UP_DEV = COMPOSE_ENVFILE=$(ENVFILE) docker compose up dev

ASTRO_URL ?= http://ci:4321
# ENVFILE ?= $(if $(wildcard .env),.env,env.template)
ENVFILE ?= env.template

ciTest: clean envfile deps check build preview testPreview clean
ciDeploy: clean envfile deps check build preview testPreview deploy clean

envfile:
	$(COMPOSE_RUN_BUSYBOX) sh -c "cp -f $(ENVFILE) .env"

# deps creates the base image used by other compose services
# It installs dependencies
deps:
	$(COMPOSE_BUILD_BASE)
	$(COMPOSE_RUN_CI) deno task install

# It copies deps from Docker volumes to the host. This is handy for auto-completion from IDE among other things.
# If there is a docker running and using the Docker volumes, it will fail deleting node_modules and vendor. Run command `docker compose down` to mitigate the issue
# TODO: I could potentially look into [dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)
copyDepsToHost:
	$(COMPOSE_RUN_BUSYBOX) sh -c "rm -fr node_modules vendor"
	docker compose create ci
	docker compose cp ci:/opt/app/node_modules .
	docker compose cp ci:/opt/app/vendor .
	docker compose rm -f ci

deploy:
	git rev-parse --is-shallow-repository
	# cat dist/about/what-is-3musketeers/index.html | grep "Last updated"

fmt \
check \
build \
toc \
update:
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
	$(info Test home page)
	curl $(ASTRO_URL) | grep "Get started" > /dev/null
	$(info Test Getting started)
	curl $(ASTRO_URL)/guides/getting-started/ | grep "Getting Started" > /dev/null

# clean removes everything that has been created
# It also deletes the deps folders, that could've been copied to the host (`make copyDepsToHost`), with `busybox` service as it does not mount them with volumens.
# There is no need to call `deno clean` as `"vendor": true` is used in `deno.jsonc`
clean:
	docker compose down
	$(COMPOSE_RUN_BUSYBOX) sh -c "rm -fr dist .env node_modules vendor .astro"
	docker compose down --rmi "all" --remove-orphans --volumes

shell:
	$(COMPOSE_RUN_CI) bash

shellDev:
	$(COMPOSE_RUN_DEV) bash
