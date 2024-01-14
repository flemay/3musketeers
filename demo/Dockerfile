# Using a build stage allows flexibility to install any version of vhs without
# the need to wait for a new version of the VHS docker version
FROM golang:alpine as build
RUN go install github.com/charmbracelet/vhs@latest

FROM ghcr.io/charmbracelet/vhs
RUN <<EOF
# Install vim, make, and docker. Ref: https://docs.docker.com/engine/install/debian/
apt-get update
apt-get install -y --no-install-recommends \
  git \
  shellcheck \
  neovim \
  make \
  ca-certificates \
  curl \
  gnupg

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Only install Docker client
apt-get install -y --no-install-recommends \
  docker-ce-cli \
  docker-compose-plugin

rm -rf /var/lib/apt/lists/*

# Test tools are installed
git --version
shellcheck --version
nvim --version
make --version
docker --version
docker compose version
EOF

COPY --from=build /go/bin/vhs /usr/bin/vhs
RUN vhs --version
COPY nvim-init.lua /root/.config/nvim/init.lua
