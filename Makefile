noTargetGuard:
	@echo "Choose a target"
	exit 1

COMPOSE_BUILD_BASE = docker compose build base
COMPOSE_RUN_DEV_MAKE = docker compose run --rm devcontainer make
COMPOSE_RUN_DEV_DENO_TASK = docker compose run --rm devcontainer deno task
COMPOSE_UP_DEV = docker compose up devcontainer
COMPOSE_RUN_DEV_WITH_PORTS = docker compose run --service-ports --rm devcontainer_with_ports
COMPOSE_UP_DEV_WITH_PORTS = docker compose up devcontainer_with_ports

ENVFILE ?= env.template

envfile:
	cp -f $(ENVFILE) .env

# deps creates the base image used by other compose services
# It installs dependencies
# It copies deps from Docker volumes to the host. This is handy for auto-completion from IDE among other things.
# TODO: I could potentially look into [dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)
deps:
	$(COMPOSE_BUILD_BASE)
	$(COMPOSE_RUN_DEV_DENO_TASK) install
	rm -fr node_modules vendor
	docker compose create devcontainer
	docker compose cp devcontainer:/opt/app/node_modules .
	docker compose cp devcontainer:/opt/app/vendor .
	docker compose rm -f devcontainer

fmt \
check \
build \
deploy:
	$(COMPOSE_RUN_DEV_DENO_TASK) $@

# TODO:
# - Instead of `sleep` Could potentially look at compose service health_check
# - https://docs.docker.com/reference/compose-file/services/#healthcheck
previewCI:
	$(info Target `preview` will sleep 5 seconds to make sure the server is up)
	COMPOSE_COMMAND="deno task preview" $(COMPOSE_UP_DEV)
	$(COMPOSE_RUN_DEV) sleep 5

dev \
preview:
	COMPOSE_COMMAND="deno task $@" $(COMPOSE_UP_DEV_WITH_PORTS)

# clean removes everything that has been created
# It also deletes the deps folders from the host (instead of container) because they were copied from the volumes with `docker compose cp`
# There is no need to call `deno clean` as `"vendor": true` is used in `deno.jsonc`
clean:
	$(COMPOSE_RUN_DEV_MAKE) _clean
	docker compose down --rmi "all" --remove-orphans --volumes
	rm -fr .env node_modules vendor

# Deleting node_modules and vendor folder will fail: `rm: cannot remove 'node_modules': Device or resource busy`. This is because both folders are part of a Docker data volume
# Moreover, there is no need to delete node_modules and vendor from within the container as the date will get deleted with `docker compose down`
_clean:
	rm -fr dist

shell:
	$(COMPOSE_RUN_DEV_WITH_PORTS) bash

