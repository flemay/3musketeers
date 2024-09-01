---
status: accepted
date: 2024-01-25
---

# Bind volume for Go app

## Context and problem statement

The demo shows the execution of a Go application with the 3 Musketeers tools: Make, Docker, and Compose. To record the demo, VHS is used and it is executed within a Docker container. This is a Docker-outside-of-Docker (DooD) situation. The source files of the demo are in directory [../app/](../app) and how it is passed to the VHS and Go containers matters.

## Decision drivers

* The solution should work with Docker-outside-of-Docker (DooD).
* The source files shown in the demo should be copied/pasted and work as is with Docker. ie No need to setup DooD.

## Considered options

* Bind volume
* Data volume

## Decision outcome

Chosen option: "Bind volume", because the code remains clean and it works with and without Docker-outside-of-Docker.

## Pros and cons of the options

### Bind volume

Bind volume for the Go containers where the `source` can be configured with `ENV_HOST_APP_DIR`.

* Good, because the code can be copied as is and work out of the box
* Bad, because the environment variable `ENV_HOST_APP_DIR` is being passed to the container. This allows VHS, inside a container, to run the Go app (Docker-outside-of-Docker). However, from a demo perspective, this can raise questions because in a normal setup (no DooD), it is not needed.

### Data volume

Instead of providing `ENV_HOST_APP_DIR` to the Go container, it would use an external Docker data volume created by VHS compose file.

* Good, because it relies on a neat Docker concept: data volume.
* Bad, because it requires an external data volume upfront which would make the code in [../app/](../app) not work as is.

Implementation:

```yml
# compose.yml
# ...
    volumes:
      # ...
      - type: volume
        source: app
        target: /opt/app
volumes:
  app:
```

```yml
# app/compose.yml
# ...
    volumes:
      - type: volume
        source: demo_app
        target: /opt/app
volumes:
  # The name of the volume created by the compose.yml above
  # can be found with the command `docker volume ls | grep demo`
  demo_app:
    external: true
```

Finally, `demo.tape` would have an instruction to copy the directory `app/` to the volume mounted on `/opt/app/` so that the Go container can have access.

## More information

* [Docker-outside-of-Docker (DooD)][linkDockerOutsideOfDocker]
* [Bind volume implementation][linkBindVolumeImplementation]


[linkBindVolumeImplementation]: ../README.md#implementation
[linkDockerOutsideOfDocker]: https://3musketeers.pages.dev/guide/patterns.html#docker-in-outside-of-docker-dind-dood
