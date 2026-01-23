# Nix Home Manager Configuration

Home Manager configuration with [DeepWork](https://github.com/Unsupervisedcom/deepwork) integration.

## Quick Start

Apply the home manager configuration:

```bash
./bin/update-home
```

Or use the alias (after first install):

```bash
update-home
```

## Using Local DeepWork

To develop with a local checkout of deepwork:

```bash
# Uses ../deepwork by default
./bin/update-home --local

# Or specify a custom path
./bin/update-home --local /path/to/deepwork
```

## Structure

```
.
├── bin/
│   └── update-home      # Script to update home manager configuration
├── home/
│   └── username/
│       └── home.nix     # Home manager configuration
├── flake.nix            # Nix flake definition
└── README.md
```

## Configuration

Edit `home/username/home.nix` to customize your home manager configuration.

For more options, see: https://home-manager-options.extranix.com/
