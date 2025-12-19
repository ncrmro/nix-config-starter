# Reuse a base image made for devcontainers.
FROM mcr.microsoft.com/vscode/devcontainers/base:bookworm

# These dependencies are required by Nix.
RUN apt update -y && \
    apt -y install --no-install-recommends curl xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Nix 2.4pre20210126.
ARG NIX_INSTALL_SCRIPT=https://github.com/numtide/nix-flakes-installer/releases/download/nix-2.4pre20210126_f15f0b8/install
RUN curl -L ${NIX_INSTALL_SCRIPT} | sudo -u vscode NIX_INSTALLER_NO_MODIFY_PROFILE=1 sh

# Configuration for Nix from the repository shared amongst developers.
RUN mkdir -p /etc/nix
COPY nix.conf /etc/nix/nix.conf

# This loads the development environment when the container is started.
COPY profile.sh /etc/profile.d/devcontainer.sh

ENV USER=vscode

# Rebuilding the container should not throw the Nix store away so we make /nix
# a volume. See `devcontainer.json` later.
VOLUME /nix
