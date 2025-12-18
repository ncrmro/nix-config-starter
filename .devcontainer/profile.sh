#!/bin/sh
# Load Nix environment
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Enter the development environment automatically
# Use DEVCONTAINER_WORKSPACE_FOLDER if available, otherwise fall back to the configured workspace
WORKSPACE="${DEVCONTAINER_WORKSPACE_FOLDER:-/workspaces/nix-config-starter}"
if [ -d "$WORKSPACE" ]; then
  cd "$WORKSPACE"
fi
