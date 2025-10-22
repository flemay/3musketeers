noTargetGuard:
	@echo "Choose a target"
	exit 1

COMPOSE_BUILD_DEV = docker compose build --no-cache devcontainer
COMPOSE_RUN_DEV = docker compose run --service-ports --rm devcontainer
COMPOSE_RUN_DEV_MAKE = docker compose run --rm devcontainer make
COMPOSE_RUN_DEV_DENO_TASK = docker compose run --rm devcontainer deno task
ENVFILE ?= env.template

envfile:
	cp -f $(ENVFILE) .env

deps:
	$(COMPOSE_BUILD_DEV)
	$(COMPOSE_RUN_DEV_DENO_TASK) install

fmt \
check \
dev \
build:
	$(COMPOSE_RUN_DEV_DENO_TASK) $@

clean:
	$(COMPOSE_RUN_DEV_DENO_TASK) clean
	docker compose down --rmi "all" --remove-orphans --volumes
	rm -fr .env

shell:
	$(COMPOSE_RUN_DEV)

