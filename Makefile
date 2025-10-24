noTargetGuard:
	@echo "Choose a target"
	exit 1

COMPOSE_BUILD = docker compose build devcontainer
COMPOSE_RUN_DEV = docker compose run --service-ports --rm devcontainer
COMPOSE_RUN_DEV_MAKE = docker compose run --rm devcontainer make
COMPOSE_RUN_DEV_DENO_TASK = docker compose run --rm devcontainer deno task
ENVFILE ?= env.template

envfile:
	cp -f $(ENVFILE) .env

deps:
	$(COMPOSE_BUILD)
	$(COMPOSE_RUN_DEV_DENO_TASK) install
	# Copy the deps from Docker volumes to host which is handy for IDE
	rm -fr node_modules vendor
	docker compose create deps
	docker compose cp devcontainer:/opt/app/node_modules .
	docker compose cp devcontainer:/opt/app/vendor .
	docker compose rm -f deps

fmt \
check \
build \
preview \
deploy:
	$(COMPOSE_RUN_DEV_DENO_TASK) $@

dev \
previewDev:
	$(COMPOSE_RUN_DEV_DENO_TASK) $@

clean:
	$(COMPOSE_RUN_DEV_MAKE) _clean
	docker compose down --rmi "all" --remove-orphans --volumes
	# Delete the deps folders from the host because they were copied from the volumes with `docker compose cp`
	rm -fr .env node_modules vendor
_clean:
	# Deleting node_modules and vendor folder will fail: `rm: cannot remove 'node_modules': Device or resource busy`. This is because both folders are part of a Docker data volume
	# Moreover, there is no need to delete node_modules and vendor from within the container as the date will get deleted with `docker compose down`
	# There is no need to call `deno clean` as `"vendor": true` is used in `deno.jsonc`
	rm -fr dist

shell:
	$(COMPOSE_RUN_DEV)

