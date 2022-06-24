COMPOSE_RUN_NODE = docker-compose run --rm node
COMPOSE_UP_NODE = docker-compose up -d node
COMPOSE_UP_NODE_DEV = docker-compose up node_dev
ENVFILE ?= env.template
SERVE_BASE_URL ?= http://node:8080

all:
	ENVFILE=env.example $(MAKE) ciTest

ciTest: envfile cleanDocker deps build serve test clean

ciDeploy: envfile cleanDocker deps build serve test deploy clean

envfile:
	cp -f $(ENVFILE) .env

deps:
	$(COMPOSE_RUN_NODE) yarn install

upgradeDeps:
	$(COMPOSE_RUN_NODE) yarn upgrade

audit:
	-$(COMPOSE_RUN_NODE) yarn outdated
	$(COMPOSE_RUN_NODE) yarn audit

shell:
	$(COMPOSE_RUN_NODE) bash

dev:
	COMPOSE_COMMAND="make _dev" $(COMPOSE_UP_NODE_DEV)
_dev:
	yarn run vitepress dev --debug --host 0.0.0.0 docs

build:
	$(COMPOSE_RUN_NODE) make _build
_build:
	yarn run vitepress build docs

serve:
	$(info serve will sleep 5 seconds to make sure the server is up)
	COMPOSE_COMMAND="make _serve" $(COMPOSE_UP_NODE)
	$(COMPOSE_RUN_NODE) sleep 5
_serve:
	yarn run vitepress serve docs

serveDev:
	COMPOSE_COMMAND="make _serve" $(COMPOSE_UP_NODE_DEV)

test:
	$(COMPOSE_RUN_NODE) make _test SERVE_BASE_URL=$(SERVE_BASE_URL)
_test:
	echo "Test home page"
	curl $(SERVE_BASE_URL) | grep "Get Started" > /dev/null
	echo "Test docs page"
	curl $(SERVE_BASE_URL)/docs/ | grep "Hello, World!" > /dev/null

deploy:
	$(COMPOSE_RUN_NODE) make _deploy
_deploy:
	yarn run netlify --telemetry-disable
	yarn run netlify deploy --dir=docs/.vuepress/dist --prod

cleanDocker:
	docker-compose down --remove-orphans

clean:
	$(COMPOSE_RUN_NODE) bash -c "rm -fr node_modules"
	$(MAKE) cleanDocker
	rm -f .env
