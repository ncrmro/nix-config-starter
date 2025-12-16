{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Import the hardware configuration module
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jdoe-home-server";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  programs.zsh.enable = true;

  # Define a user account.
  users.users.jdoe = {
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
