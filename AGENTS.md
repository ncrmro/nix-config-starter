# Agent Context & Instructions

This repository contains **Nix**, **NixOS**, and **Home Manager** configurations for managing systems and user environments.

## Core Concepts

*   **Flakes (`flake.nix`):** The entry point. It defines inputs (dependencies) and outputs (system/user configurations).
*   **NixOS (`hosts/`):** System-level configuration (bootloader, kernel, hardware, global services).
*   **Home Manager (`home/`):** User-level configuration (dotfiles, shell aliases, user-specific packages).
*   **Agenix (`secrets.nix`):** Secret management. Secrets are encrypted with SSH keys and stored in `.age` files.

## Directory Structure

*   `flake.nix`: Defines `nixosConfigurations` (machines) and `homeConfigurations` (standalone user environments).
*   `hosts/<hostname>/default.nix`: Main configuration for a specific NixOS machine (e.g., `workstation`, `server`).
*   `home/<username>/home.nix`: Main configuration for a specific user (e.g., `username`).
*   `secrets.nix`: Configuration for Agenix. Maps secrets to public keys.

## Common Workflows

### 1. Adding a System-Wide Package (NixOS)

Edit `hosts/<hostname>/default.nix` (e.g., `hosts/workstation/default.nix`):

```nix
environment.systemPackages = with pkgs; [
  git
  vim
  # Add new package here
];
```

### 2. Adding a User-Specific Package (Home Manager)

Edit `home/<username>/home.nix` (e.g., `home/username/home.nix`):

```nix
home.packages = with pkgs; [
  ripgrep
  jq
  # Add new package here
];
```

### 3. Managing Secrets

**Do NOT write secrets in plain text (nix files).**

1.  Add public keys to `secrets.nix`.
2.  Create/Edit secret: `agenix -e secrets/<name>.age`
3.  Reference in config:
    ```nix
    age.secrets.<name>.file = ../../secrets/<name>.age;
    ```

### 4. Applying Changes

*   **NixOS:** `sudo nixos-rebuild switch --flake .#<hostname>`
*   **Home Manager:** `nix run home-manager/master -- switch --flake .#<config-name>`

## Style Guidelines

*   Prefer **comments** explaining *why* a complex configuration exists.
*   Keep `flake.nix` clean; import modules from `hosts/` or `home/` rather than defining them inline.
*   Use `pkgs.lib.mkDefault` for hardware config values to allow overrides.