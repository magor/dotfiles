{config, pkgs, lib, ... }:

{
  stylix = {
    enable = true;
    polarity = "dark";
    image = ./wp.jpg;
    opacity.terminal = 0.95;
    fonts.sizes.terminal = 11;
    fonts.sizes.applications = 11;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
  };
  specialisation.light.configuration = {
    stylix = {
      polarity = lib.mkForce "light";
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/gruvbox-material-light-medium.yaml";
    };
  };
}
