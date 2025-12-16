{ pkgs, ... }: {
  home.username = "jdoe";
  home.homeDirectory = "/home/jdoe";
  home.stateVersion = "24.05";
  
  programs.home-manager.enable = true;
}
