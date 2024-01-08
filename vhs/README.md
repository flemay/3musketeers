# VHS - Demo

This is self-content code to generate the 3 Musketeers demo with [charmbracelet/vhs](https://github.com/charmbracelet/vhs).

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
    make-record[make record]-->|1|host-docker-client[Docker client]
    host-docker-client-->|2|docker-daemon((Docker daemon))
    subgraph vhs-local-container [Container: 3musketeers-vhs:local]
    vhs-->|4|make-run[make run]
    make-run-->|5|docker-client[Docker client]
    end
    docker-daemon-->|3|vhs-local-container
    docker-client-->|6|docker-daemon
    dir-vhs{{"**Directory: vhs**
    Dockerfile
    Makefile
    demo.tape
    docker-compose.yml
    src/"}}
    vhs-local-container-..->|volume:bind|dir-vhs
    docker-daemon-->|7|golang-alpine-container
    subgraph golang-alpine-container [Container: golang:alpine]
        go-run[go run]
    end
    dir-vhs-src{{"**Directory: vhs/src**
    Makefile
    docker-compose.yml
    main.go"}}
    golang-alpine-container-.->|volume:bind|dir-vhs-src
    go-run-->|8|hello-world('Hello, World!')
    vhs-->|9\nouput/demo.mp4|dir-vhs
```

## References

- [VHS](https://github.com/charmbracelet/vhs)
- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)
- [VHS Themes](https://github.com/flemay/vhs-themes)
