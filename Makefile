COMPOSE_RUN_DEV = docker-compose run --rm dev
COMPOSE_UP_DEV = docker-compose up dev
NETLIFYCTL=netlifyctl
CHROMA_STYLE=monokai

# ENVFILE is .env.template by default but can be overwritten
ENVFILE ?= .env.template

travis:
	ENVFILE=.env.template $(MAKE) envfile deps build deploy clean
.PHONY: travis

# envfile creates or overwrites .env with $(ENVFILE)
envfile:
	cp -f $(ENVFILE) .env
.PHONY: envfile

deps: dockerBuild
	$(COMPOSE_RUN_DEV) npm install
.PHONY: deps

dockerBuild:
	docker-compose build dev
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

# deploy will only deploy to netlify if TRAVIS_BRANCH is master
deploy:
	$(COMPOSE_RUN_DEV) make _deploy
.PHONY: deploy

clean:
	$(COMPOSE_RUN_DEV) bash -c "rm -fr node_modules public resources/_gen"
	docker-compose down --remove-orphans
.PHONY: clean

_build:
	rm -fr resources/_gen
	hugo -b $${HUGO_BASE_URL}
.PHONY: _build

_server:
	rm -fr resources/_gen
	hugo server -b $${HUGO_BASE_URL} --bind="0.0.0.0"
.PHONY: _server

_deploy:
	@set -e; if [ "$(TRAVIS_BRANCH)" = "master" ]; then \
		$(NETLIFYCTL) --yes -A $(NETLIFY_TOKEN) deploy --site-id $(NETLIFY_SITE_ID); \
		echo " DEPLOYED!"; \
	else \
		ech " SKIPPED deployment"; \
	fi;
.PHONY: _deploy

# _generateChromaStyle creates the code highlighting.
# Only use it if needing an updated since the source file is already checked in.
_generateChromaStyle:
	hugo gen chromastyles --style=$(CHROMA_STYLE) > assets/css/chroma.css
.PHONY: _generateChromaStyle