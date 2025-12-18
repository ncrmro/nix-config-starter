{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Import the hardware configuration module
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "username-home-server";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  programs.zsh.enable = true;

  # Enable SSH access
  services.openssh.enable = true;

  # Root user SSH access (replace with your key
  users.users.root.openssh.authorizedKeys.keys =
    [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyr ...." ];

  # Define a user account.
  users.users.username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 7d";
  };

  system.stateVersion = "24.05";
}
