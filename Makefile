COMPOSE_PULL = docker-compose pull
COMPOSE_RUN_NODE = docker-compose run --rm node
COMPOSE_UP_NODE = docker-compose up -d node
COMPOSE_UP_NODE_DEV = docker-compose up node_dev
ENVFILE ?= env.template
SERVE_BASE_URL ?= http://node:5173

all:
	ENVFILE=env.example $(MAKE) ciTest

ciTest: envfile pruneDocker deps build serve test prune

ciDeploy: envfile pruneDocker deps build serve test deploy prune

envfile:
	cp -f $(ENVFILE) .env

deps:
	$(COMPOSE_PULL) node
	$(COMPOSE_RUN_NODE) npm install

depsUpgrade:
	$(COMPOSE_PULL)
	$(COMPOSE_RUN_NODE) npm upgrade

depsAudit:
	-$(COMPOSE_RUN_NODE) npm outdated
	$(COMPOSE_RUN_NODE) npm audit

depsCopy:
	rm -fr node_modules
	docker compose create deps
	docker compose cp deps:/opt/deps/node_modules .
	docker compose rm -f deps

shell:
	$(COMPOSE_RUN_NODE) bash

dev:
	COMPOSE_COMMAND="make _dev" $(COMPOSE_UP_NODE_DEV)
_dev:
	npx vitepress dev --host 0.0.0.0 docs

build:
	$(COMPOSE_RUN_NODE) make _build
_build:
	npx vitepress build docs

serve:
	$(info serve will sleep 5 seconds to make sure the server is up)
	COMPOSE_COMMAND="make _serve" $(COMPOSE_UP_NODE)
	$(COMPOSE_RUN_NODE) sleep 5
_serve:
	npx vitepress serve docs --port 5173

serveDev:
	COMPOSE_COMMAND="make _serve" $(COMPOSE_UP_NODE_DEV)

test:
	$(COMPOSE_RUN_NODE) make _test SERVE_BASE_URL=$(SERVE_BASE_URL)
_test:
	echo "Test home page"
	curl $(SERVE_BASE_URL) | grep "Get started" > /dev/null
	echo "Test docs page"
	curl $(SERVE_BASE_URL)/guide/getting-started.html | grep "Hello, World!" > /dev/null

deploy:
	$(COMPOSE_RUN_NODE) make _deploy
_deploy:
	npx netlify --telemetry-disable
	npx netlify deploy --dir=docs/.vitepress/dist --prod

pruneDocker:
	docker-compose down --remove-orphans --volumes

prune:
	$(COMPOSE_RUN_NODE) bash -c "rm -fr docs/.vitepress/dist docs/.vitepress/.cache"
	$(MAKE) pruneDocker
	rm -fr .env node_modules

toc:
	$(COMPOSE_RUN_NODE) make _toc
_toc:
	npx doctoc README.md --notitle
	npx doctoc tutorials
