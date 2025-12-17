# Nix Config Starter

This project is a basic Nix configuration starter. It began with a standard `nix flake init` and has been extended to include the `keystone` flake input.

- **Nix:** The package manager and language. It builds software in isolation to prevent version conflicts.
- **Home Manager:** Manages your user config (dotfiles, git config, shell aliases, VS Code extensions).
- **NixOS:** The operating system built on Nix. You describe the state you want (bootloader, drivers, timezone) in one file, and NixOS builds it.
- **Flakes:** The project structure. It uses a `flake.lock` file to pin dependencies (like nixpkgs) to exact git commits, guaranteeing that if you build this config on another machine 5 years from now, it will be identical.

## Why Nix/NixOS?

Nix and NixOS offer significant advantages over other established solutions for system and dotfile management like Homebrew, traditional dotfile managers (e.g., Stow, Ansible), or other Linux distributions with their native package managers (apt, dnf, pacman). The core benefits of Nix and NixOS stem from their unique approach to package management and system configuration:

-   **Reproducibility:** Nix ensures that your development environment and system configuration are exactly the same, every time, everywhere. This is achieved by building everything from source with pinned dependencies (via `flake.lock`), eliminating "it works on my machine" issues.
-   **Declarative Configuration:** Instead of a sequence of imperative commands, you describe the *desired state* of your system and user environment in Nix files. Nix then figures out how to get there. This makes your configuration readable, auditable, and easy to understand.
-   **Atomic Upgrades and Rollbacks:** Changes to your system (upgrades, new packages) are transactional. If a new configuration breaks something, you can instantly roll back to a previous working state with a single command, without affecting your data.
-   **Isolated Environments:** Nix allows you to create isolated development environments for different projects, each with its own specific dependencies, without interfering with other projects or your global system. This is superior to virtual environments or containers for managing developer tools directly.
-   **Purity:** Nix builds packages in "pure" environments, meaning they don't depend on anything outside their explicitly declared inputs. This prevents dependency hell and ensures that builds are consistent and reliable.
-   **Cross-Distribution Compatibility:** Nix can be installed on any Linux distribution and macOS, allowing you to manage packages and user environments declaratively, bringing the benefits of Nix to your existing system. NixOS extends this to the entire operating system.

In essence, Nix and NixOS offer a powerful, principled, and ultimately more reliable way to manage software and systems, reducing complexity and increasing confidence in your configurations across all your machines.

## Features

- **Base Flake:** Initialized with `nix flake init`.
- **Keystone Input:** Added `https://github.com/ncrmro/keystone` to `inputs` and `outputs` in `flake.nix`.
- **Agenix:** Secret management using SSH keys.

## Keystone

This configuration leverages the [Keystone](https://github.com/ncrmro/keystone) flake, which offers two primary inputs for your Nix configurations:

-   **TUI Tools:** A preconfigured set of Terminal User Interface (TUI) tools designed for use with Home Manager, providing a consistent and powerful command-line experience.
-   **Desktop Hyprland:** A full-featured desktop environment based on the Hyprland Wayland compositor, offering a modern and efficient graphical experience.

These inputs allow for flexible integration of either the command-line tools, the desktop environment, or both, into your Nix-managed system.

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

*Note: In the examples below, replace `jdoe` with your actual username or the identifier you use in your Home Manager/NixOS configuration.*

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

## GitHub Copilot Setup

This repository is configured to work with GitHub Copilot for AI-assisted development. The configuration includes:

### Continuous Integration

A GitHub Actions workflow (`.github/workflows/test.yml`) automatically validates changes on every pull request by:

- Checking out the repository code
- Installing Nix with flakes support
- Running `nix flake check` to validate configuration correctness

This ensures that all Nix configurations are syntactically correct and properly structured before merging changes.

### Using Copilot with Nix

When working with Copilot in this repository:

- Copilot understands the declarative Nix syntax and can help write configurations
- The `AGENTS.md` file provides context about the repository structure for AI assistants
- All changes are validated automatically through CI before they can be merged