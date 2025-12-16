# Nix Config Starter

This project is a basic Nix configuration starter. It began with a standard `nix flake init` and has been extended to include the `keystone` flake input.

- **Nix:** The package manager and language. It builds software in isolation to prevent version conflicts.
- **Home Manager:** Manages your user config (dotfiles, git config, shell aliases, VS Code extensions).
- **NixOS:** The operating system built on Nix. You describe the state you want (bootloader, drivers, timezone) in one file, and NixOS builds it.
- **Flakes:** The project structure. It uses a `flake.lock` file to pin dependencies (like nixpkgs) to exact git commits, guaranteeing that if you build this config on another machine 5 years from now, it will be identical.

## Features

- **Base Flake:** Initialized with `nix flake init`.
- **Keystone Input:** Added `https://github.com/ncrmro/keystone` to `inputs` and `outputs` in `flake.nix`.
- **Agenix:** Secret management using SSH keys.

## Directory Structure

The project is organized as follows:

```
├── flake.nix                   # Entry point: inputs (repos) and outputs (systems)
├── flake.lock                  # Auto-generated lock file
├── secrets.nix                 # Agenix secret rules (who can decrypt what)
├── hosts/                      # NixOS Machine-specific configurations
│   ├── jdoe-workstation/       # Desktop/Workstation config
│   │   ├── default.nix         # Imports hardware + modules specific to this host
│   │   └── hardware-configuration.nix
│   └── jdoe-server/            # Server config (headless)
│       ├── default.nix
│       └── hardware-configuration.nix
└── home/                       # Home Manager configurations (packages and dotfiles)
    └── jdoe/
        └── home.nix            # The entry point for jdoe's Home Manager
```

## Usage

This repository serves as a template or starting point for managing a user's home folder or OS using NixOS.

### Applying Configurations

**Home Manager (User-only):**
```bash
nix run home-manager/master -- switch --flake .#jdoe-macbook
```

**NixOS (System-wide):**
```bash
sudo nixos-rebuild switch --flake .#jdoe-workstation
```

**NixOS (Remote Server):**
```bash
nixos-rebuild switch --flake .#jdoe-home-server --target-host "root@192.168.1.33"
```

### Managing Secrets

1.  Add public SSH keys to `secrets.nix`.
2.  Create/Edit a secret:
    ```bash
    agenix -e secrets/my-secret.age
    ```
3.  Reference it in your Nix config (see `flake.nix` examples).