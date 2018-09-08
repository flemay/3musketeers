COMPOSE_RUN_HUGO = docker-compose run --rm hugo
COMPOSE_UP_HUGO = docker-compose up hugo
COMPOSE_RUN_NETLIFY = docker-compose run --rm netlify
ENVFILE ?= .env.template

travis:
	ENVFILE=.env.template $(MAKE) envfile deps build deploy clean
.PHONY: travis

# envfile creates or overwrites .env with $(ENVFILE)
envfile:
	cp -f $(ENVFILE) .env
.PHONY: envfile

deps:
	docker-compose pull hugo netlify
	$(COMPOSE_RUN_HUGO) npm install
.PHONY: deps

generateChromaStyle:
	$(COMPOSE_RUN_HUGO) ./scripts/generate_chroma_style.sh
.PHONY: generateChromaStyle

shellHugo:
	$(COMPOSE_RUN_HUGO) bash
.PHONY: shellHugo

shellNetlify:
	$(COMPOSE_RUN_NETLIFY)
.PHONY: shellNetlify

server:
	$(COMPOSE_UP_HUGO)
.PHONY: server

build:
	$(COMPOSE_RUN_HUGO) ./scripts/build.sh
.PHONY: build

deploy:
	$(COMPOSE_RUN_NETLIFY) ./scripts/deploy.sh
.PHONY: deploy

clean:
	$(COMPOSE_RUN_HUGO) bash -c "rm -fr node_modules public resources/_gen"
	docker-compose down --remove-orphans
.PHONY: clean