MAKEFILE_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
HOST_SRC_DIR = $(MAKEFILE_DIR)src
COMPOSE_BUILD_VHS = docker compose build vhs
COMPOSE_RUN_VHS = ENV_HOST_SRC_DIR=$(HOST_SRC_DIR) docker compose run --rm vhs
COMPOSE_RUN_VHS_BASH = ENV_HOST_SRC_DIR=$(HOST_SRC_DIR) docker compose run --rm --entrypoint bash vhs

all: deps record prune

deps:
	$(COMPOSE_BUILD_VHS)

record:
	$(COMPOSE_RUN_VHS) demo.tape

shell:
	$(COMPOSE_RUN_VHS_BASH)

prune:
	docker compose down --remove-orphans --volumes
