# Compose

Docker Compose, or simply Compose, manages Docker containers in a very neat way. It allows multiple Docker commands to be written as a single one, which allows our Makefile to be a lot cleaner and easier to maintain. Testing also often involves container dependencies, such as a database, which is an area where Compose really shines. No need to create the database container and link it to your application code container manually — Compose takes care of this for you.

## Multiple Docker networks

By default, Compose creates a Docker network based on the project's name. All services can talk to each other within the same network. The network's name can be configured by setting the environment variable [COMPOSE_PROJECT_NAME][linkComposeProjectName]. This variable can be set in a `.env` file. This is useful when wanting to have different environments locally. For instance, the network's name could be based on an environment such as `my_project_dev`.

[linkComposeProjectName]: https://docs.docker.com/compose/reference/envvars/
