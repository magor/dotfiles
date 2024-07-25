{config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    #wineWowPackages.waylandFull
    winetricks
  ];
}
