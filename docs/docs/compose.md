# Compose

## Composition over Inheritance

With Docker, it is pretty easy to have all the tooling a project needs inside one image. However, if the project requires a new dependency, the image would need to be modified, tested, and rebuilt. In order to avoid this, use dedicated images that do specific things.

## Multiple Docker Network

By default, Compose creates a Docker network based on the project's name. All services can talk to each other within the same network. The network's name can be configured by setting the environment variable [COMPOSE_PROJECT_NAME][linkComposeProjectName]. This variable can be set in a `.env` file. This is useful when wanting to have different environments locally. For instance, the network's name could be based on an environment such as `my_project_dev`.

[linkComposeProjectName]: https://docs.docker.com/compose/reference/envvars/
