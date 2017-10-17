HANDLER ?= handler
PACKAGE ?= package
ifdef DOTENV
	DOTENV_TARGET=dotenv
else
	DOTENV_TARGET=.env
endif

################
# Entry Points #
################

# test tests the application
test: $(DOTENV_TARGET)
	docker-compose run --rm goshim make _depsGo _test
.PHONY: test

# build tests the application and creates the serverless artifact to be deployed
build: $(DOTENV_TARGET)
	docker-compose run --rm goshim make _depsGo _test _build
.PHONY: build

# deploy deploys the serverless artifact
deploy: $(ARTIFACT_NAME) $(DOTENV_TARGET)
	docker-compose run --rm serverless make _deploy
.PHONY: deploy

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

##########
# Others #
##########

# .env creates .env based on .env.template if .env does not exist
.env:
	@echo "Create .env with .env.template"
	cp .env.template .env

# dotenv creates/overwrites .env with $(DOTENV)
dotenv:
	@echo "Overwrite .env with $(DOTENV)"
	cp $(DOTENV) .env
.PHONY: dotenv

# _depsGo installs go dependencies for the project
_depsGo:
	dep ensure
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
	rm -rf $(HANDLER).so $(PACKAGE).zip .serverless vendor
.PHONY: _clean