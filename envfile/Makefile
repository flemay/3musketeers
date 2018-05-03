ENVFILE = .env
# DOCKER_RUN_ENVVARS is the docker command to run envvars. The reason why it is not part of the docker-compose.yml is because Compose will fail if there is no ".env" file.
DOCKER_RUN_ENVVARS = docker run --rm -v $(PWD):/opt/app -w /opt/app flemay/envvars:0.0.3 envfile

# shell creates a shell environment inside a container. It uses .env by default unless ENVFILE is set.
shell: $(ENVFILE)
	docker-compose run --rm alpine sh
.PHONY: shell

# .env creates .env based on envvars.yml
.env:
	$(DOCKER_RUN_ENVVARS) envfile

# .envfileExample creates .env with example values based on envvars.yml
envfileExample:
	$(DOCKER_RUN_ENVVARS) envfile --example --overwrite
.PHONY: envfileExample

# cleanDocker remove all containers/network created by Compose
cleanDocker: $(ENVFILE)
	docker-compose down --remove-orphans
.PHONY: cleanDocker

# clean cleans the current directory
clean: cleanDocker
	rm -f .env
.PHONY: clean