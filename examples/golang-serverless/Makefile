HANDLER ?= main
PACKAGE ?= package
GOLANG_DEPS_ARTIFACT = golang_vendor.zip
GOLANG_DEPS_DIR = vendor
ifdef DOTENV
	DOTENV_TARGET=dotenv
else
	DOTENV_TARGET=.env
endif

####################
# Pipeline targets #
####################

# deps installs all dependencies for testing/building/deploying. This example only has golang dependencies
deps: $(DOTENV_TARGET)
	docker-compose run --rm serverlessGo make _depsGo
.PHONY: deps

# test tests the application
test: $(DOTENV_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm serverlessGo make _test
.PHONY: test

# build tests the application and creates the serverless artifact to be deployed
build: $(DOTENV_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm serverlessGo make _build
.PHONY: build

# deploy deploys the serverless artifact
deploy: $(DOTENV_TARGET) $(ARTIFACT_NAME)
	docker-compose run --rm serverlessGo make _deploy
.PHONY: deploy

#############################
# Other entry point targets #
#############################

# remove removes the api gateway and the lambda
remove: $(DOTENV_TARGET)
	docker-compose run --rm serverlessGo make _remove
.PHONY: remove

# shellGolang let you run a shell inside a go container
shell: $(DOTENV_TARGET)
	docker-compose run --rm serverlessGo bash
.PHONY: shell

echo: $(DOTENV_TARGET)
	docker-compose run --rm serverlessGo make _echo
.PHONY: echo

###################
# Files/Artifacts #
###################

# .env creates .env based on .env.template if .env does not exist
.env:
	@echo "Create .env with .env.template"
	cp .env.template .env

# dotenv creates/overwrites .env with $(DOTENV)
dotenv:
	@echo "Overwrite .env with $(DOTENV)"
	cp $(DOTENV) .env
.PHONY: dotenv

# if there is no vendor directory then unzip from golang_vendor.zip artefact
$(GOLANG_DEPS_DIR): | $(GOLANG_DEPS_ARTIFACT)
	unzip -qo -d . $(GOLANG_DEPS_ARTIFACT)

##########
# Others #
##########

# _depsGo installs go dependencies for the project and zip them into an artifact
_depsGo:
	dep ensure
	zip -rq $(GOLANG_DEPS_ARTIFACT) $(GOLANG_DEPS_DIR)/
.PHONY: _depsGo

# _test tests the go source
_test:
	go test -v
.PHONY: _test

# build makes a golang binary and zip it for the serverless package
_build:
	GOOS=linux go build -o bin/main
	zip -r $(PACKAGE).zip bin
.PHONY: _build

# _deploy deploys the package using serverless
_deploy:
	rm -fr .serverless
	sls deploy -v
.PHONY: _deploy

# _echo calls the echo api endpoint
_echo:
	sls info -f echo | grep GET | cut -d' ' -f 5 | xargs curl
.PHONY: _echo

# _remove removes the aws stack created by serverless
_remove:
	sls remove -v
	rm -fr .serverless
.PHONY: _remove

# _clean cleans the repo from the created artifacts
_clean:
	rm -rf .serverless *.zip $(GOLANG_DEPS_DIR) .env bin
.PHONY: _clean