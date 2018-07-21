COMPOSE_RUN_DEV = docker-compose run --rm dev
COMPOSE_UP_DEV = docker-compose up dev
NETLIFYCTL=netlifyctl
CHROMA_STYLE=monokai

# ENVFILE is .env.template by default but can be overwritten
ENVFILE ?= .env.template

# envfile creates or overwrites .env with $(ENVFILE)
envfile:
	cp -f $(ENVFILE) .env
.PHONY: envfile

deps: dockerBuild
	$(COMPOSE_RUN_NODE) npm install
.PHONY: deps

dockerBuild:
	docker-compose build --no-cache dev
.PHONY: dockerBuild

shell:
	$(COMPOSE_RUN_DEV) bash
.PHONY: shell

server:
	$(COMPOSE_UP_DEV)
.PHONY: server

build:
	$(COMPOSE_RUN_DEV) make _build
.PHONY: build

deploy:
	$(COMPOSE_RUN_DEV) make _deploy
.PHONY: deploy

clean:
	rm -fr static node_modules public
	docker-compose down --remove-orphans
.PHONY: clean

# _generateChromaStyle creates the code highlighting.
# Only use it if needing an updated since the source file is already checked in.
_generateChromaStyle:
	hugo gen chromastyles --style=$(CHROMA_STYLE) > assets/css/chroma.css
.PHONY: _generateChromaStyle

_build:
	hugo -b $${HUGO_BASE_URL}
.PHONY: _build

_server:
	hugo server -b $${HUGO_BASE_URL} --bind="0.0.0.0"
.PHONY: _server

_deploy:
	@$(NETLIFYCTL) --yes -A $${NETLIFY_TOKEN} deploy --site-id $${NETLIFY_SITE_ID}
.PHONY: _deploy