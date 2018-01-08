HANDLER ?= handler
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

# deps installs all dependencies for testing/building. This example only has golang dependencies
deps: $(DOTENV_TARGET)
	docker-compose run --rm goshim make _depsGo
.PHONY: deps

# test tests the application
test: $(DOTENV_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm goshim make _test
.PHONY: test

# build tests the application and creates the serverless artifact to be deployed
build: $(DOTENV_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm goshim make _build
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

# shellServerless let you run bash inside a serverless container
shellServerless: $(DOTENV_TARGET)
	docker-compose run --rm serverless bash
.PHONY: shellServerless

# shellGo let you run bash inside a goshim container
shellGo: $(DOTENV_TARGET)
	docker-compose run --rm goshim bash
.PHONY: shellGo

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
	go build -buildmode=plugin -ldflags='-w -s' -o $(HANDLER).so
	chown $(shell stat -c '%u:%g' .) $(HANDLER).so
	pack $(HANDLER) $(HANDLER).so $(PACKAGE).zip
	chown $(shell stat -c '%u:%g' .) $(HANDLER).so $(PACKAGE).zip
.PHONY: _build

# _deploy deploys the package using serverless
_deploy:
	rm -fr .serverless
	sls deploy -v
.PHONY: _deploy

# _remove removes the aws stack created by serverless
_remove:
	sls remove -v
	rm -fr .serverless
.PHONY: _remove

# _clean cleans the repo from the created artifacts
_clean:
	rm -rf $(HANDLER).so $(PACKAGE).zip .serverless $(GOLANG_DEPS_ARTIFACT) $(GOLANG_DEPS_DIR) .env
.PHONY: _clean