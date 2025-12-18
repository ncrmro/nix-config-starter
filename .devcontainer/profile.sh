#!/bin/sh
# Load Nix environment
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Enter the development environment automatically
if [ -d /workspaces/nix-config-starter ]; then
  cd /workspaces/nix-config-starter
fi
