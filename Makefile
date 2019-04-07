COMPOSE_RUN_VUEPRESS = docker-compose run --rm vuepress
COMPOSE_UP_VUEPRESS = docker-compose up vuepress
COMPOSE_RUN_NETLIFY = docker-compose run --rm netlify
COMPOSE_RUN_SHELLCHECK = docker-compose run --rm shellcheck
ENVFILE ?= .env.template

all:
	ENVFILE=.env.example $(MAKE) envfile deps build clean

travisPullRequest: envfile deps build clean

travisMasterChange: envfile deps build deploy clean

envfile:
	cp -f $(ENVFILE) .env

deps:
	docker-compose pull vuepress netlify
	$(COMPOSE_RUN_VUEPRESS) yarn install

shellVuepress:
	$(COMPOSE_RUN_VUEPRESS) sh

shellNetlify:
	$(COMPOSE_RUN_NETLIFY)

dev:
	$(COMPOSE_UP_VUEPRESS)

test:
	$(COMPOSE_RUN_SHELLCHECK) scripts/*.sh
.PHONY: test

build:
	$(COMPOSE_RUN_VUEPRESS) ./scripts/build.sh

deploy:
	$(COMPOSE_RUN_NETLIFY) ./scripts/deploy.sh

clean:
	$(COMPOSE_RUN_VUEPRESS) ./scripts/clean.sh
	docker-compose down --remove-orphans
	rm -f .env
