{ pkgs, ... }: {
  home.username = "jdoe";
  home.homeDirectory = "/Users/jdoe";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Shell aliases
  home.shellAliases = {
    # Update home manager configuration
    # Use: update-home
    # Or:  update-home --local         (use local deepwork flake at ../deepwork)
    # Or:  update-home --local /path   (use local deepwork flake at custom path)
    update-home = "~/code/nix-config-starter/bin/update-home";
  };
}
