# The 3 Musketeers

The 3 Musketeers is a pattern for developing software in a repeatable and consistent manner. It leverages Make as an orchestration tool to test, build, run, and deploy applications using Docker and Docker Compose. The Make and Docker/Compose commands for each application are maintained as part of the application’s source code and are invoked in the same way whether run locally or on a CI/CD server.

Read More on [Medium](https://amaysim.engineering/the-3-musketeers-how-make-docker-and-compose-enable-us-to-release-many-times-a-day-e92ca816ef17).

## Guidelines

Read the [guidelines](https://github.com/flemay/3musketeers/blob/master/GUIDELINES.md)

## Prerequisites for the examples

- [Docker](https://docs.docker.com/engine/installation/)
- [Compose](https://docs.docker.com/compose/install/)
- Make
- AWS credentials in ~/.aws or environment variables (only for deploying to AWS)

> For Windows users, PowerShell is recommended and make can be installed with [scoop](https://github.com/lukesampson/scoop).

## Download this repository

```bash
# using Docker
$ docker run --rm -v ${PWD}:/git -w /git alpine sh -c "apk --update add git openssh && git clone https://github.com/flemay/3musketeers.git"

# using Git
 git clone https://github.com/flemay/3musketeers.git
```

## Links

- [Tutorial](https://github.com/flemay/3musketeers/tree/master/envfile) on how `.env` works with Docker and Compose
- My [slides](https://www.slideshare.net/FredericLemay/the-three-musketeers-83691981) of my talk about the 3 Musketeers at Sydney Docker Meetup