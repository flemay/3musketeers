---
title: Compose
draft: false
date:
lastmod:
description: Contains best practices and tips related to Compose and the 3 Musketeers.
weight: 300
toc: true
---

# Compose

## Composition over Inheritance

With Docker, it is pretty easy to have all the tooling a project needs inside one image. However, if the project requires a new dependency, the image would need to be modified, tested, and rebuilt. In order to avoid this, use dedicated images that do specific things.

## Multiple Docker Network

By default Compose creates a Docker network named based on the project's name. All services can talk to each other within the same network. The network's name can be configured by setting the environment variable [COMPOSE_PROJECT_NAME][composeProjectName]. This variable can be set in a `.env` file. This is useful when wanting to have different environments locally. For instance, the network's name could be based on the environment like `my_project_dev`.

[composeProjectName]: https://docs.docker.com/compose/reference/envvars/