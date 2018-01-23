# The 3Musketeers

## Prerequisites for the examples

- [Docker](https://docs.docker.com/engine/installation/)
- [Compose](https://docs.docker.com/compose/install/)
- Make
- AWS credentials in ~/.aws or environment variables (only for deploying to AWS)

> For Windows users, PowerShell is recommended and make can be installed with [scoop](https://github.com/lukesampson/scoop).

## Downloading this repository

There are few ways to download this repository.

### Using Docker

Docker can be used for many things, even for cloning a repo!

```bash
$ docker run --rm -v ${PWD}:/git -w /git alpine sh -c "apk --update add git openssh && git clone https://github.com/flemay/3musketeers.git"
```

### Using Git and the command-line

`$ git clone https://github.com/flemay/3musketeers.git`

### Download from GitHub website

1. Go to [https://github.com/flemay/3musketeers](https://github.com/flemay/3musketeers)
2. Click on the "Clone or download" green button
3. Download ZIP

## Links

- 3Musketeers [guidelines](https://github.com/flemay/3musketeers/blob/master/GUIDELINES.md)
- Tutorial on how `.env` works with Docker and Compose
- My [slides](https://www.slideshare.net/FredericLemay/the-three-musketeers-83691981) of my talk about the 3Musketeers at Sydney Docker Meetup