{config, pkgs, pkgs-teamviewer, inputs, ... }:

{
  services.teamviewer.enable = true; # client doesn't work without running service :(
  #services.teamviewer.package = pkgs-teamviewer.teamviewer;
  environment.systemPackages = with pkgs; [
    obsidian
    parsec-bin
    mariadb
    #beekeeper-studio # marked as insecure
  ];
}
