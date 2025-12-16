# Nix Config Starter

This project is a basic Nix  configuration starter. It began with a standard `nix flake init` and has been extended to include the `keystone` flake input.

- Nix: The package manager and language. It builds software in isolation to prevent version conflicts.
- Home Manager: Manages your user config (dotfiles, git config, shell aliases, VS Code extensions).
- NixOS: The operating system built on Nix. You describe the state you want (bootloader, drivers, timezone) in one file, and NixOS builds it.
- Flakes: The project structure. It uses a flake.lock file to pin dependencies (like nixpkgs) to exact git commits, guaranteeing that if you build this config on another machine 5 years from now, it will be identical.

## Features

- **Base Flake:** Initialized with `nix flake init`.
- **Keystone Input:** Added `https://github.com/ncrmro/keystone` to `inputs` and `outputs` in `flake.nix`.

## Directory Structure

The project is organized as follows:

```
├── flake.nix                   # Entry point: inputs (repos) and outputs (systems)
├── flake.lock                  # Auto-generated lock file
├── hosts/                      # NixOS Machine-specific configurations
│   ├── desktop/
│   │   ├── default.nix         # Imports hardware + modules specific to desktop
│   │   └── hardware-configuration.nix
│   └── laptop/
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/                    # Reusable code blocks (custom options)
│   ├── nixos/                  # System-level modules (e.g., docker.nix, gaming.nix)
│   └── home-manager/           # User-level modules (e.g., zsh.nix, neovim.nix)
├── home/                       # nix home-manager (packages and dotfiles for the users home folder)
│   ├── root/
│   │   └── home.nix            # The entry point for root's Home Manager
│   ├── jdoe/
│   │   └── home.nix
└── pkgs/                       # Custom packages not found in upstream nixpkgs
```

## Usage

This repository serves as a template or starting point for managing a NixOS fleet and user configurations using Flakes.
