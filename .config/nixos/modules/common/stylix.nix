{
  pkgs,
  lib,
  stylix,
  ...
}:

{
  imports = [
    stylix.nixosModules.stylix
  ];

  stylix = {
    targets = {
      # QT_STYLE_OVERRIDE=kvantum
      # https://github.com/nix-community/stylix/issues/835
      # https://github.com/nix-community/stylix/issues/1092
      qt.enable = false;
    };

    enable = true;
    polarity = "dark";
    image = lib.custom.relativeToRoot "assets/wp.jpg";
    opacity.terminal = 0.95;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
  };
  specialisation.light.configuration = {
    environment.etc."specialisation".text = "light";
    stylix = {
      polarity = lib.mkForce "light";
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/gruvbox-material-light-medium.yaml";
    };
  };
}
