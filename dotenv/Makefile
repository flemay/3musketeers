# Specifying DOTENV allows you to choose a file as your .env file
ifdef DOTENV
	DOTENV_TARGET=dotenv
else
	DOTENV_TARGET=.env
endif

# shell creates a shell environment inside a container. It uses .env by default unless DOTENV is set.
shell: $(DOTENV_TARGET)
	docker-compose run --rm alpine sh
.PHONY: shell

# .env creates a .env based on .env.template if .env does not exist
.env:
	cp .env.template .env

# Create/Overwrite .env with $(DOTENV)
dotenv:
	cp $(DOTENV) .env
.PHONY: dotenv

# clean cleans the current directory
clean:
	docker-compose run --rm alpine sh -c "rm -f .env"
.PHONY: clean