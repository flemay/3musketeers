# VHS - Demo

This is self-content code to generate the 3 Musketeers demo with [charmbracelet/vhs](https://github.com/charmbracelet/vhs).

[![Watch the video](something)](../../vhs-demo/demo.mp4)

## Prerequisites

- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)

## Usage

```bash
# Build dependencies such as the Docker image
make deps
# Record the demo
make record
# Clean up
make prune
```

## Implementation

```mermaid
graph TB
    make-record[make record]-->|1\ndocker compose run vhs demo.tape|host-docker-client[Docker client]
    host-docker-client-->|2|docker-daemon((Docker daemon))
    subgraph vhs-local-container [Container: 3musketeers-vhs:local]
    vhs[vhs demo.tape]-->|4|make-run["cd src/
    make run"]
    make-run-->|5\ndocker compose run golang go run main.go|docker-client[Docker client]
    end
    docker-daemon-->|3|vhs-local-container
    docker-client-->|6|docker-daemon
    dir-vhs{{"**Host directory: vhs/**
    Dockerfile
    Makefile
    demo.tape
    docker-compose.yml
    src/Makefile
    src/docker-compose.yml
    ..."}}
    vhs-local-container-...->|volume:bind\nvhs/ <-> /opt/src/|dir-vhs
    docker-daemon-->|7|golang-alpine-container
    subgraph golang-alpine-container [Container: golang:alpine]
        go-run[go run main.go]
    end
    dir-vhs-src{{"**Host directory: vhs/src/**
    main.go
    ..."}}
    golang-alpine-container-.->|volume:bind\nvhs/src/ <-> /opt/app/|dir-vhs-src
    go-run-->|8|hello-world[/'Hello, World!'/]
    vhs-->|9\nouput/demo.mp4|dir-vhs
```

Flow:

1. `make record` sends the command `docker compose run vhs demo.tape` with the Docker client
2. The Docker client sends it to the Docker daemon
3. The Docker daemon creates a service `vhs`
	- The details of the service is defined in `docker-compose.yml`
	- The container is based on Docker image `flemay/3musketeers-vhs:local`
	- The image `flemay/3musketeers-vhs:local` definition comes from `Dockerfile`. It is based on `ghcr.io/charmbracelet/vhs` and adds required tools for the demo such as: `nvim`, `make`, `docker`, and `compose`.
	- A volume is created which maps the host directory `src/` to container directory `/opt/src/`. This makes the file `demo.tape` accessible to `vhs` inside the container.
	- `vhs demo.tape` is then executed
4. `vhs demo.tape` calls the commands `cd src/` and `make run`
5. `make run` executes the command `docker compose golang go run main.go` with the Docker client (inside the container)
6. The Docker client (inside the container) passes the command to Docker daemon (on the host)
	- This is possible because the service `vhs` (defined in `docker-compose.yml`) mounts the host `/var/run/docker.sock`
7. The Docker daemon creates a service `golang`
	- The container is based on the official Go Docker image
	- The details of the service is in `src/docker-compose.yml`
	- The service `golang` defines a volume that maps the host directory `vhs/src/` to the container directory `/opt/app/`. That directory contains the source file `main.go`
		- It is important to note that the full path to the host directory `vhs/src/` is passed to the service (using environment variable `ENV_HOST_SRC_DIR`) and not the container path `/opt/src/src/` even if the command originated from the container `vhs`. This is because the Docker daemon (being outside of the container) would not know the location of `/opt/src/src/`
	- `go run main.go` is executed inside the container
8. `Hello, World!` is printed out
9. `vhs` saves the record `demo.mp4` into directory `/opt/src/output/` which is also accessible from the host directory `vhs/output/`

## References

- [VHS](https://github.com/charmbracelet/vhs)
- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)
- [VHS Themes](https://github.com/flemay/vhs-themes)
