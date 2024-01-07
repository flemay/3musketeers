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

## Overview

![demo-overview](./demo-overview.svg)

```mermaid
graph TB
    make:record[make record]-->host-docker-client[Docker client]
    host-docker-client-->docker-daemon[Docker daemon]
    subgraph vhs:local-container
    make:run[make run]-->docker-client[Docker client]
    end
    docker-client-->docker-daemon
    docker-daemon-->vhs:local-container
    vhs:local-container-.volume:bind.->dir:vhs{{dir:vhs\n- Makefile\n- docker-compose.yml}}
    docker-daemon-->golang:alpine-container
    subgraph golang:alpine-container
        go:run
    end
    golang:alpine-container-.volume:bind.->dir:vhs/src{{dir:vhs/src\n- Makefile\n- main.go}}
```

## References

- [VHS](https://github.com/charmbracelet/vhs)
- [Docker](https://www.docker.com/)
- [Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)
- [VHS Themes](https://github.com/flemay/vhs-themes)
