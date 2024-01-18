COMPOSE_PULL = docker compose pull
COMPOSE_RUN_MERMAID_SH = docker-compose run --rm --entrypoint sh mermaid

all: deps mermaid prune

deps:
	$(COMPOSE_PULL) mermaid

mermaid:
	$(COMPOSE_RUN_MERMAID_SH) run_mermaid.sh

shell:
	$(COMPOSE_RUN_MERMAID_SH)

prune:
	docker-compose down --remove-orphans --volumes
