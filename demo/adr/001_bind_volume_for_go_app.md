---
status: accepted
date: 2024-01-25
---

# AD: Bind volume for Go app

## Context and problem statement

The demo shows the execution of a Go application with the 3 Musketeers tools: Make, Docker, and Compose. To record the demo, VHS is used and it is executed within a Docker container. This is a Docker-outside-of-Docker (DooD) situation. The source files of the demo are in directory `./src` and how it is passed to the VHS and Go containers matters.

## Decision Drivers

- The source files shown in the demo should be copied/pasted and work as is with Docker. ie No need to setup DooD.
- The solution should work with DooD.

## Considered options

1. Bind volume and the host path is provided to VHS and Go containers.
2. Data volume is created for VHS container. Go container to use the VHS container.

## Decision outcome

Bind volume was chosen as it is the cleanest solution based on the decision drivers.

## Consequences

- Good, because the code can be copied as is and work out of the box
- Bad, because the environment variable `ENV_HOST_SRC_DIR` is being passed to the container. This allows VHS, inside a container, to run the Go app (Docker-outside-of-Docker). However, from a demo perspective, this can raise questions because in a normal setup (no DooD), it is not needed.

## Pros and Cons of the options

### Data volume

Instead of providing `ENV_HOST_SRC_DIR` to the Go container, it would use an external Docker data volume created by VHS compose file.

- Good, because it relies on a neat Docker concept: data volume.
- Bad, because it requires an external data volume upfront which would make the code not working as is.

Implementation:

```yml
# docker-compose.yml
# ...
    volumes:
      # ...
      - type: volume
        source: go_src
        target: /opt/go_src
volumes:
  go_src:
```

```yml
# src/docker-compose.yml
# ...
    volumes:
      - type: volume
        source: demo_go_src
        target: /opt/go_src
volumes:
  # The name of the volume created by the docker-compose.yml above
  # can be found with `docker volume ls | grep demo`\
  demo_go_src:
    external: true
```

Finally, `demo.tape` would have an instruction to copy the directory `src/` to the volume mounted on `/opt/go_src/` so that the Go container can have access.

## More information

- [Docker-outside-of-Docker (DooD)][linkDockerOutsideOfDocker]
- [Bind volume implementation][linkBindVolumeImplementation]


[linkBindVolumeImplementation]: ../README#implementation
[linkDockerOutsideOfDocker]: https://3musketeersdev.netlify.app/guide/patterns.html#docker-in-outside-of-docker-dind-dood
