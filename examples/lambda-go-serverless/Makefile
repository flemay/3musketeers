BIN_DIR = bin
BIN_PACKAGES_ARTIFACT = bin_packages.zip
GOLANG_DEPS_ARTIFACT = golang_vendor.zip
GOLANG_DEPS_DIR = vendor
ifdef ENVFILE
	ENVFILE_TARGET=envfile
else
	ENVFILE_TARGET=.env
endif

# all is the default Make target. it installs the dependencies, tests, and builds the application
all: deps test build pack
.PHONY: all

####################
# Pipeline targets #
####################

# deps installs all dependencies for testing/building/deploying. This example only has golang dependencies
deps: $(ENVFILE_TARGET)
	docker-compose run --rm golang make _depsGo
	docker-compose run --rm serverless make _zipGoDeps
.PHONY: deps

# test tests the application
test: $(ENVFILE_TARGET) $(GOLANG_DEPS_DIR)
	docker-compose run --rm golang make _test
.PHONY: test

# build tests the application and creates the serverless artifact to be deployed
build: $(GOLANG_DEPS_DIR)
	docker-compose run --rm golang make _build
.PHONY: build

# pack zips all binary functions individually and zip the bin dir into 1 artifact
pack:
	docker-compose run --rm serverless make _pack
.PHONY: pack

# deploy deploys the serverless artifact
deploy: $(ENVFILE_TARGET) $(BIN_DIR)
	docker-compose run --rm serverless make _deploy
.PHONY: deploy

#############################
# Other entry point targets #
#############################

# remove removes the api gateway and the lambda
remove: $(ENVFILE_TARGET)
	docker-compose run --rm serverless make _remove
.PHONY: remove

# shellGolang let you run a shell inside a go container
shellGolang: $(ENVFILE_TARGET)
	docker-compose run --rm golang bash
.PHONY: shellGolang

# shellServerless let you run a shell inside a serverless container
shellServerless: $(ENVFILE_TARGET)
	docker-compose run --rm serverless bash
.PHONY: shellServerless

# echo calls the echo API endpoint
echo: $(ENVFILE_TARGET)
	docker-compose run --rm serverless make _echo
.PHONY: echo

# clean removes build artifacts
clean: $(ENVFILE_TARGET)
	docker-compose run --rm golang make _clean
.PHONY: clean

###################
# Files/Artifacts #
###################

# .env creates .env based on .env.template if .env does not exist
.env:
	cp .env.template .env

# envfile creates/overwrites .env with $(ENVFILE)
envfile:
	cp $(ENVFILE) .env
.PHONY: envfile

# if there is no vendor directory then unzip from golang_vendor.zip artifact
$(GOLANG_DEPS_DIR): | $(GOLANG_DEPS_ARTIFACT)
	docker-compose run --rm serverless make _unzipGoDeps

# if bin directory is not present, it unzips all the zip binaries into bin directory
$(BIN_DIR): | $(BIN_PACKAGES_ARTIFACT)
	docker-compose run --rm serverless make _unzipBinPackagesArtifact

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

# _clean cleans the repo from the created artifacts
_clean:
	rm -rf .serverless *.zip $(GOLANG_DEPS_DIR) .env bin
.PHONY: _clean
