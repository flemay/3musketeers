MAKEFILE_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
HOST_SRC_DIR = $(MAKEFILE_DIR)src
COMPOSE_BUILD_VHS = docker compose build vhs
COMPOSE_RUN_VHS = ENV_HOST_SRC_DIR=$(HOST_SRC_DIR) docker compose run --rm vhs
COMPOSE_RUN_VHS_BASH = ENV_HOST_SRC_DIR=$(HOST_SRC_DIR) docker compose run --rm --entrypoint bash vhs
ENVFILE ?= env.template

all: envfile deps record prune

envfile:
	cp -f $(ENVFILE) .env

deps:
	$(COMPOSE_BUILD_VHS)

test:
	$(COMPOSE_RUN_VHS_BASH) -c "make _test"
_test:
	shellcheck --enable all *.sh

record:
	$(COMPOSE_RUN_VHS) demo.tape

shell:
	$(COMPOSE_RUN_VHS_BASH)

publish:
	$(COMPOSE_RUN_VHS_BASH) -c "make _publish"
_publish:
	./run_git_publish.sh

prune:
	$(COMPOSE_RUN_VHS_BASH) -c "rm -fr output"
	docker compose down --remove-orphans --volumes
