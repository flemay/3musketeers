# Host user in container

One of the great benefits of the 3musketeers pattern is to allow tasks to be run within a consistent environment, regardless of what the host environment is like. This consistency is largely acheived through the isolation and decoupling from the host that docker and containers provide.

By default, however, this also means that the container within which tasks are run have no knowledge of the user (from the host) that is running the task, and this can sometimes be problematic, in the following ways:

- Any files written from within the container to a volume mount (mapped back to the host) will have `root` file permissions, breaking from the normal file ownership expectations on the host, i.e. that the files would be owned by the user that ran the task. This can lead to confusing situations such as getting permission errors when trying to delete those files, and needing to resort to either using `sudo` to delete them, or having to run another container just to delete the files!

- Many tools expect to be able to interact with the user's home directory for things like storing/reading user-specific settings and accessing user-specific credentials (e.g. AWS CLI stores both settings and credentials in the user home directory by default), and while these things may be correctly configured for the host user, they will fail to be found correctly within the container, since the container environment will have it's own, independent user home directory (for the `root` user, by default)

- Some tools/programs expect to be able to resolve the current user's details from the OS's user database, which from within the container will not match the equivalent details from the host, resulting in problems with the correct operation of the tool/program

Below are some strategies for addressing each of these situations where it is important for the host user details to be matched inside the container for performing a task.

## File permissions

Aligining file permissions is quite straightforward to solve, and it is probably best to apply this solution upfront to any 3musketeers setup to avoid file permission surprises down the track. We simply need to ensure that the `docker compose` (or `docker run`, if using the [Docker][linkPatternDocker] pattern) command explicitly sets the user for the container to match the host user:

```makefile
# Makefile
...
	docker-compose run --rm --user "$(id -u):$(id -g)" ...



# Or for "Docker" pattern:
...
	docker run --rm --user "$(id -u):$(id -g)" ...
```

## Home directory

The majority<sup>*</sup> of use cases that require resolution of the user home directory can be solved through volume mounts into the container and setting the `$HOME` environment variable to match. Where possible, limit the mounted directories (or even just files, if possible) to those that are required, and ensure that they are mounted as read-only. If this is not possible, it may be necessary to mount the entire user directory:

```yaml
# docker-compose.yml

# Example: AWS CLI settings and credentials (read-only)
...
    volumes:
      - ~/.aws/config:/alt_home/.aws/config:ro
      - ~/.aws/credentials:/alt_home/.aws/credentials:ro
      - ...
    environment:
      - HOME=/alt_home
      - ...

# Example: entire user directory with read/write (try to avoid if possible):
...
    volumes:
      - ~:/alt_home
      - ...
    environment:
      - HOME=/alt_home
      - ...
```

_**Note:**_ This strategy can often also be used to control other default paths that tools may expect to find. E.g. here's the same strategy used to map a custom cache directory for the Gradle build system (via `GRADLE_USER_HOME`):

```yaml
# docker-compose.yml
...
    volumes:
      - ~/my/custom/gradle/home:/gradle_home
      - ...
    environment:
      - GRADLE_USER_HOME=/gradle_home
      - ...
```

<sup>* There are some exceptions (such as SSH, explored in the example at the bottom of this page) which rely instead (or in addition) upon the user home details recorded in the OS User database. For these cases, the strategies discussed below would be required</sup>

## OS user database

In essence, the "user database" on Linux (which will apply inside any Linux container) is the combination of the `/etc/passwd` and `/etc/group` files. We can take advantage of this by volume mounting in those 2 files containing the user details required into the container.

On a Linux host, the host user details can be fully matched into the container from the host files. It is strongly recommended to do so only in read-only mode to guard against any accidental modification and/or corruption of the host user details from within the container:

```yaml
# docker-compose.yml
...
    volumes:
      - /etc/passwd:/etc/passwd:ro
      - /etc/group:/etc/group:ro
      - ...
```

On Windows and macOS hosts however, things are little more complicated, for two reasons:

- these host OS's implement their user databases differently
- there is a Linux Virtual Machine under the hood, which is where Docker actually runs

And so while it is possible to simply define direct volume mounts for `/etc/passwd` and `/etc/group` (as on Linux), what ends up happening on Windows and macOS hosts (even on macOS where these files do at least exist on the host) is that copies of these files from the _Linux VM_ get mounted into the container, with no relationship back to the user details on the host.

As a result, what we need to do is to translate the details of the host user into the container ourselves, by supplying customised `/etc/passwd` and `/etc/group` files into the container with the necessary details. These custom `/etc/passwd` and `/etc/group` files will need to be placed in a location that is folder mapped into Docker's Linux VM (see Docker documentation for details: [Docker for Mac](https://docs.docker.com/docker-for-mac/osxfs/#namespaces) or [Docker for Windows](https://docs.docker.com/docker-for-windows/#file-sharing)) and volume mounted into the container with the appropriate `volumes` entries in the `docker-compose.yml` file.

The example below of enabling `git clone` with SSH keys has samples of what these custom `/etc/passwd` and `/etc/group` files might look like.


## Example: `git clone` (via SSH) inside container

Being able to perform a `git clone` from inside a container, while using the host user's SSH keys for authentication (e.g. to fetch Terraform modules from a private Git repository) is a scenario where all of the 3 approaches above need to be used in tandem.

Below is an example of how this can be achieved from a macOS host (just to add in the extra complication of the Linux VM in the middle!):

<sup>(Note: this example uses the [Shell Command][linkPatternShellCommand] pattern to enable direct use of the `alpine/git` image, i.e. without having to install `make` in the image)</sup>

```shell
# Example macOS host user details (will be different for other hosts/users)

> id
uid=501(adumas) gid=20(staff) groups=20(staff)
```

```yaml
# docker-compose.yml

version: '3'
services:
  git:
    image: alpine/git
    working_dir: /opt/app
    volumes:
      - .:/opt/app
      # SSH key pair strictly read-only
      - ~/.ssh/id_rsa.pub:/alt_home/.ssh/id_rsa.pub:ro
      - ~/.ssh/id_rsa:/alt_home/.ssh/id_rsa:ro
      # 'known_hosts' file writable for ease of use, but where possible prefer read-only
      - ~/.ssh/known_hosts:/alt_home/.ssh/known_hosts
      # Custom   'passwd' and 'group' files (see further below for content)
      - ~/passwd:/etc/passwd:ro
      - ~/group:/etc/group:ro
    environment:
      - HOME=/alt_home
```

```makefile
# Makefile
clone:
	docker-compose run --rm --user "$(id -u):$(id -g)" git sh -c 'git clone git@github.com:flemay/3musketeers.git'
```

```shell
# ~/passwd

root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/mail:/sbin/nologin
news:x:9:13:news:/usr/lib/news:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucppublic:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
man:x:13:15:man:/usr/man:/sbin/nologin
nobody:x:65534:65534:nobody:/:/sbin/nologin
hostuser:x:501:20:hostuser:/alt_home:/bin/bash
```

```shell
# ~/group

root:x:0:root
bin:x:1:root,bin,daemon
daemon:x:2:root,bin,daemon
sys:x:3:root,bin,adm
adm:x:4:root,adm,daemon
tty:x:5:
disk:x:6:root,adm
lp:x:7:lp
mem:x:8:
kmem:x:9:
wheel:x:10:root
mail:x:12:mail
news:x:13:news
uucp:x:14:uucp
man:x:15:man
nogroup:x:65534:
staff:x:20:root,hostuser
```

```shell
make clone
```


[linkPatternDocker]: patterns#docker
[linkPatternShellCommand]: patterns#shell-command
