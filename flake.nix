{
  description = "Home Manager configuration with DeepWork";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deepwork.url = "github:Unsupervisedcom/deepwork";
  };

  outputs = { self, nixpkgs, home-manager, deepwork, ... }@inputs: {
    # Home Manager Configuration (Standalone)
    # Manages user-specific configuration (dotfiles, shell setup, user packages, etc.) independently of the OS.
    # Useful for non-NixOS systems (like macOS or generic Linux).
    #
    # To apply changes for 'macbook':
    # $ nix run home-manager/master -- switch --flake .#macbook
    # Or use: ./bin/update-home
    homeConfigurations = {
      "macbook" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/username/home.nix ];
      };
    };
  };
}
