{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    keystone.url = "github:ncrmro/keystone";
    # You could use home-manager directly, but the keystone flake includes it as well.
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, keystone, ... }@inputs: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # Home Manager Configuration (Standalone)
    # Manages user-specific configuration (dotfiles, shell setup, user packages, etc.) independently of the OS.
    # Useful for non-NixOS systems (like macOS or generic Linux).
    #
    # To apply changes for 'jdoe-macbook':
    # $ nix run home-manager/master -- switch --flake .#jdoe-macbook
    homeConfigurations = {
      "jdoe-macbook" = keystone.inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/jdoe/home.nix
        ];
      };
    };

    # NixOS Configuration
    # Manages the entire system configuration (kernel, system services, hardware, networking, users, etc.).
    #
    # To apply changes for 'jdoe-workstation':
    # $ sudo nixos-rebuild switch --flake .#jdoe-workstation
    nixosConfigurations = {
      "jdoe-workstation" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/jdoe-workstation/default.nix

          # Example: Managing Home Manager through NixOS
          #
          # This approach allows you to manage user configurations (dotfiles) as part of the system generation.
          #
          # Benefits:
          # 1. Atomic Rollbacks: Reverting the system generation also reverts the home environment (dotfiles, packages).
          # 2. Sync: Ensures system and user configurations are always in sync.
          #
          # keystone.inputs.home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.jdoe = import ./home/jdoe/home.nix;
          #   home-manager.extraSpecialArgs = { inherit inputs; };
          # }
        ];
      };
    };


  };
}