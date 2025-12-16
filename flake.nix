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
    #
    # Git Configuration Example (User-specific):
    # To configure Git for a specific user via Home Manager (e.g., in ./home/jdoe/home.nix):
    # programs.git = {
    #   enable = true;
    #   userName = "John Doe";
    #   userEmail = "john.doe@example.com";
    # };
    # This enables git, installs the binary, and manages the user's ~/.gitconfig.
    # This git installation and configuration is only accessible to this specific user.
    # More Home Manager options can be found at: https://home-manager-options.extranix.com/
    homeConfigurations = {
      "jdoe-macbook" =
        keystone.inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home/jdoe/home.nix ];
        };
    };

    # NixOS Configuration
    # Manages the entire system configuration (kernel, system services, hardware, networking, users, etc.).
    #
    # For more NixOS packages, see: https://search.nixos.org/packages
    # For more NixOS options, see: https://search.nixos.org/options
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

          # Git Configuration Example (System-wide):
          # To install Git system-wide for all users via NixOS (e.g., in ./hosts/jdoe-workstation/default.nix):
          # environment.systemPackages = with pkgs; [
          #   git # Installs git for the whole OS, making it available to any user.
          # ];
          # This installs git globally on the system, making it available to all users.

        ];
      };

      # To apply changes for 'jdoe-home-server':
      # $ sudo nixos-rebuild switch --flake .#jdoe-home-server
      #
      # ###
      # # Installing from a diffrent host running nix
      # nixos-rebuild switch --flake .#jdoe-home-server --target-host "root@$192.168.1.33"
      "jdoe-home-server" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Server Configuration Example:
          # Enabling Nginx (Web Server) and Gitea (Git Service)
          #
          # services.nginx = {
          #   enable = true;
          #   virtualHosts."git.example.com" = {
          #     enableACME = true;
          #     forceSSL = true;
          #     locations."/".proxyPass = "http://localhost:3000";
          #   };
          # };
          #
          # services.gitea = {
          #   enable = true;
          #   settings.server.HTTP_PORT = 3000;
          #   settings.server.ROOT_URL = "https://git.example.com/";
          # };
          #
          # Example: ACME (SSL) with Cloudflare DNS & Secrets Management (Agenix)
          # Agenix uses SSH keys for encryption/decryption, ensuring secrets are kept out of the Nix store
          # and proper permissions are enforced.
          #
          # 1. Create the secret:
          #    $ agenix -e secrets/cloudflare-api-token.age
          #    (Enter your Cloudflare API token in the file and save)
          #
          # 2. Add the Agenix module and configure ACME:
          #
          # imports = [ inputs.agenix.nixosModules.default ];
          #
          # age.secrets.cloudflare-api-token.file = ./secrets/cloudflare-api-token.age;
          #
          # security.acme = {
          #   acceptTerms = true;
          #   defaults.email = "jdoe@example.com";
          # };
          #
          # services.nginx.virtualHosts."git.example.com" = {
          #   enableACME = true;
          #   forceSSL = true;
          #   useACMEHost = "git.example.com"; # Or define a wildcart cert
          #   acmeRoot = null;
          #   extraConfig = ''
          #     # ... other nginx config
          #   '';
          # };
          #
          # security.acme.certs."git.example.com" = {
          #   domain = "git.example.com";
          #   dnsProvider = "cloudflare";
          #   # Path to the file containing the API token (managed by agenix)
          #   credentialsFile = config.age.secrets.cloudflare-api-token.path;
          # };

        ];
      };
    };

  };
}
