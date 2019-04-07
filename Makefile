COMPOSE_RUN_VUEPRESS = docker-compose run --rm vuepress
COMPOSE_UP_VUEPRESS_DEV = docker-compose up vuepress_dev
COMPOSE_UP_VUEPRESS = docker-compose up --detach vuepress
COMPOSE_RUN_NETLIFY = docker-compose run --rm netlify
COMPOSE_RUN_SHELLCHECK = docker-compose run --rm shellcheck
COMPOSE_RUN_DOCKERIZE = docker-compose run --rm dockerize
COMPOSE_RUN_TESTCAFE = docker-compose run --rm testcafe
ENVFILE ?= .env.template

all:
	ENVFILE=.env.example $(MAKE) envfile deps lint start test build clean

travisPullRequest: envfile deps lint start test build clean

travisMasterChange: envfile deps lint start test build deploy clean

envfile:
	cp -f $(ENVFILE) .env

deps:
	docker-compose pull vuepress netlify testcafe dockerize shellcheck
	$(COMPOSE_RUN_VUEPRESS) yarn install

shellVuepress:
	$(COMPOSE_RUN_VUEPRESS) sh

shellTestCafe:
	$(COMPOSE_RUN_TESTCAFE)

shellNetlify:
	$(COMPOSE_RUN_NETLIFY)

startDev:
	$(COMPOSE_UP_VUEPRESS_DEV)

start:
	$(COMPOSE_UP_VUEPRESS)
	$(COMPOSE_RUN_DOCKERIZE) -wait tcp://vuepress:8080 -timeout 60s

lint:
	$(COMPOSE_RUN_SHELLCHECK) scripts/*.sh
	$(COMPOSE_RUN_VUEPRESS) npx eslint test/*.ts

test:
	$(COMPOSE_RUN_TESTCAFE) scripts/test.sh
.PHONY: test

build:
	$(COMPOSE_RUN_VUEPRESS) scripts/build.sh

deploy:
	$(COMPOSE_RUN_NETLIFY) scripts/deploy.sh

cleanDocker:
	docker-compose down --remove-orphans

clean:
	$(COMPOSE_RUN_VUEPRESS) scripts/clean.sh
	$(MAKE) cleanDocker
	rm -f .env
