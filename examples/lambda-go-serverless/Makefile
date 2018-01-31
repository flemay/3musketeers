PACKAGE ?= package
GOLANG_DEPS_ARTIFACT = golang_vendor.zip
GOLANG_DEPS_DIR = vendor
ifdef DOTENV
	DOTENV_TARGET=dotenv
else
	DOTENV_TARGET=.env
endif

# all is the default Make target. it installs the dependencies, tests, and builds the application
all: deps test build
.PHONY: all

####################
# Pipeline targets #
####################

# deps installs all dependencies for testing/building/deploying. This example only has golang dependencies
deps: $(DOTENV_TARGET)
	docker-compose run --rm golang make _depsGo
.PHONY: deps

# test tests the application
test: $(DOTENV_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm golang make _test
.PHONY: test

# build tests the application and creates the serverless artifact to be deployed
build: $(GOLANG_DEPS_DIR)
	docker-compose run --rm golang make _build
.PHONY: build

# deploy deploys the serverless artifact
deploy: $(DOTENV_TARGET) $(ARTIFACT_NAME)
	docker-compose run --rm serverless make _deploy
.PHONY: deploy

#############################
# Other entry point targets #
#############################

# remove removes the api gateway and the lambda
remove: $(DOTENV_TARGET)
	docker-compose run --rm serverless make _remove
.PHONY: remove

# shellGolang let you run a shell inside a go container
shellGolang: $(DOTENV_TARGET)
	docker-compose run --rm golang bash
.PHONY: shellGolang

# shellServerless let you run a shell inside a serverless container
shellServerless: $(DOTENV_TARGET)
	docker-compose run --rm golang bash
.PHONY: shellServerless

# echo calls the echo API endpoint
echo: $(DOTENV_TARGET)
	docker-compose run --rm serverless make _echo
.PHONY: echo

# clean removes build artifacts
clean: $(DOTENV_TARGET)
	docker-compose run --rm golang make _clean
.PHONY: clean

###################
# Files/Artifacts #
###################

# .env creates .env based on .env.template if .env does not exist
.env:
	cp .env.template .env

# dotenv creates/overwrites .env with $(DOTENV)
dotenv:
	cp $(DOTENV) .env
.PHONY: dotenv

# if there is no vendor directory then unzip from golang_vendor.zip artifact
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
	sls deploy
.PHONY: _deploy

# _echo calls the echo api endpoint
_echo:
	sls info -f echo | grep GET | cut -d' ' -f 5 | xargs curl
.PHONY: _echo

# _remove removes the aws stack created by serverless
_remove:
	sls remove
	rm -fr .serverless
.PHONY: _remove

# _clean cleans the repo from the created artifacts
_clean:
	rm -rf .serverless *.zip $(GOLANG_DEPS_DIR) .env bin
.PHONY: _clean
