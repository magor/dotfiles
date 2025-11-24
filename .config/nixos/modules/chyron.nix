{ pkgs, ... }:

{
  services.teamviewer.enable = true; # client doesn't work without running service :(
  environment.systemPackages = with pkgs; [
    obsidian
    parsec-bin
  ];
}
