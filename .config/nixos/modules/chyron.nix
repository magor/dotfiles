{config, pkgs, inputs, ... }:

{
  services.teamviewer.enable = true; # client doesn't work without running service :(
  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
