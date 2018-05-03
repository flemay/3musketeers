BIN_DIR = bin
BIN_PACKAGES_ARTIFACT = bin_packages.zip
GOLANG_DEPS_ARTIFACT = golang_vendor.zip
GOLANG_DEPS_DIR = vendor
ENVFILE = .env
# DOCKER_RUN_ENVVARS is the docker command to run envvars. The reason why it is not part of the docker-compose.yml is because Compose will fail if there is no ".env" file.
DOCKER_RUN_ENVVARS = docker run --rm -v $(PWD):/opt/app -w /opt/app flemay/envvars:0.0.3 envfile
COMPOSE_RUN_GOLANG = docker-compose run --rm golang
COMPOSE_RUN_SERVERLESS = docker-compose run --rm serverless

# all is the default Make target. it installs the dependencies, tests, and builds the application
all: deps test build pack
.PHONY: all

####################
# Pipeline targets #
####################

# deps installs all dependencies for testing/building/deploying. This example only has golang dependencies
deps: $(ENVFILE)
	$(COMPOSE_RUN_GOLANG) make _depsGo
	$(COMPOSE_RUN_SERVERLESS) make _zipGoDeps
.PHONY: deps

# test tests the application
test: $(ENVFILE) $(GOLANG_DEPS_DIR)
	$(COMPOSE_RUN_GOLANG) make _test
.PHONY: test

# build tests the application and creates the serverless artifact to be deployed
build: $(ENVFILE) $(GOLANG_DEPS_DIR)
	$(COMPOSE_RUN_GOLANG) make _build
.PHONY: build

# pack zips all binary functions individually and zip the bin dir into 1 artifact
pack: $(ENVFILE)
	$(COMPOSE_RUN_SERVERLESS) make _pack
.PHONY: pack

# deploy deploys the serverless artifact
deploy: $(ENVFILE) $(BIN_DIR)
	$(DOCKER_RUN_ENVVARS) ensure
	$(COMPOSE_RUN_SERVERLESS) make _deploy
.PHONY: deploy

#############################
# Other entry point targets #
#############################

# shellGolang let you run a shell inside a go container
shellGolang: $(ENVFILE)
	$(COMPOSE_RUN_GOLANG) bash
.PHONY: shellGolang

# shellServerless let you run a shell inside a serverless container
shellServerless: $(ENVFILE)
	$(COMPOSE_RUN_SERVERLESS) bash
.PHONY: shellServerless

# echo calls the echo API endpoint
echo: $(ENVFILE)
	$(DOCKER_RUN_ENVVARS) ensure
	$(COMPOSE_RUN_SERVERLESS) make _echo
.PHONY: echo

# remove removes the api gateway and the lambda
remove: $(ENVFILE)
	$(DOCKER_RUN_ENVVARS) ensure
	$(COMPOSE_RUN_SERVERLESS) make _remove
.PHONY: remove

cleanDocker: $(ENVFILE)
	docker-compose down --remove-orphans
.PHONY: cleanDocker

# clean removes build artifacts
clean: cleanDocker
	$(COMPOSE_GOLANG) make _clean
	$(MAKE) cleanDocker
.PHONY: clean

############
# env file #
############

# .env creates .env based on envvars.yml
.env:
	$(DOCKER_RUN_ENVVARS) envfile

# .envfileExample creates .env with example values based on envvars.yml
envfileExample:
	$(DOCKER_RUN_ENVVARS) envfile --example --overwrite
.PHONY: envfileExample

###################
# Artifacts #
###################

# if there is no vendor directory then unzip from golang_vendor.zip artifact
$(GOLANG_DEPS_DIR): | $(GOLANG_DEPS_ARTIFACT)
	$(COMPOSE_RUN_SERVERLESS) make _unzipGoDeps

# if bin directory is not present, it unzips all the zip binaries into bin directory
$(BIN_DIR): | $(BIN_PACKAGES_ARTIFACT)
	$(COMPOSE_RUN_SERVERLESS) make _unzipBinPackagesArtifact

##########
# Others #
##########

# _depsGo installs go dependencies for the project
_depsGo:
	dep ensure
.PHONY: _depsGo

# _zipGoDeps zips the go dependencies so they can be passed along with a single zip file
_zipGoDeps:
	zip -rq $(GOLANG_DEPS_ARTIFACT) $(GOLANG_DEPS_DIR)/
.PHONY: _zipGoDeps

# _unzipGoDeps unzips the go dependencies zip file
_unzipGoDeps:
	unzip -qo -d . $(GOLANG_DEPS_ARTIFACT)
.PHONY: _unzipGoDeps

# _unzipBinPackagesArtifact unzips the artifact that contains the binary packages
_unzipBinPackagesArtifact:
	unzip -qo -d . $(BIN_PACKAGES_ARTIFACT)
.PHONY: _unzipBinPackagesArtifact

# _unzipGolangDepsArtifact unzips the golang dependencies artifact which contains all the dependencies
_unzipGolangDepsArtifact:
	unzip -qo -d . $(GOLANG_DEPS_ARTIFACT)
.PHONY: _unzipGolangDepsArtifact

# _test tests the go source
_test:
	go test -v ./...
.PHONY: _test

# build builds all functions individually
_build:
	@for dir in $(wildcard functions/*/) ; do \
		fxn=$$(basename $$dir) ; \
		GOOS=linux go build -ldflags="-s -w" -o $(BIN_DIR)/$$fxn functions/$$fxn/*.go ; \
	done
.PHONY: _build

# _pack zips all binary functions individually and zip the bin dir into 1 artifact
_pack:
	@for dir in $(wildcard functions/*/) ; do \
		fxn=$$(basename $$dir) ; \
		zip -m -D $(BIN_DIR)/$$fxn.zip $(BIN_DIR)/$$fxn ; \
	done
		zip -r $(BIN_PACKAGES_ARTIFACT) $(BIN_DIR)
.PHONY: _pack

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

# _clean removes folders and files created when building
_clean:
	rm -rf .serverless *.zip $(GOLANG_DEPS_DIR) .env bin
.PHONY: _clean