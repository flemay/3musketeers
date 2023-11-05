COMPOSE_BUILD_VHS = docker compose build vhs
COMPOSE_RUN_VHS = docker compose run --rm vhs
COMPOSE_RUN_VHS_BASH = docker compose run --rm --entrypoint bash vhs

all: deps record prune

deps:
	$(COMPOSE_BUILD_VHS)

record:
	$(COMPOSE_RUN_VHS) 3musketeers.tape

shell:
	$(COMPOSE_RUN_VHS_BASH)

prune:
	docker compose down --remove-orphans --volumes
