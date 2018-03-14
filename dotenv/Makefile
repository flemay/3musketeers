# Specifying ENVFILE allows you to choose a file as your .env file
ifdef ENVFILE
	ENVFILE_TARGET=envfile
else
	ENVFILE_TARGET=.env
endif

# shell creates a shell environment inside a container. It uses .env by default unless ENVFILE is set.
shell: $(ENVFILE_TARGET)
	docker-compose run --rm alpine sh
.PHONY: shell

# .env creates a .env based on .env.template if .env does not exist
.env:
	cp .env.template .env

# Create/Overwrite .env with $(ENVFILE)
envfile:
	cp $(ENVFILE) .env
.PHONY: envfile

# clean cleans the current directory
clean: $(ENVFILE_TARGET)
	docker-compose run --rm alpine sh -c "rm -f .env"
.PHONY: clean