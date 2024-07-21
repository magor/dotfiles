{config, pkgs, ... }:

{
  # https://wiki.hyprland.org/Nix/Cachix/
  #nix.settings = {
  #  substituters = ["https://hyprland.cachix.org"];
  #  trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  #};

  programs = {
    hyprland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    waybar
    hypridle
    hyprpaper
    hyprcursor
    hyprlock
    xdg-desktop-portal-hyprland
  ];

  services = {
    blueman.enable = true;
  };

  security = {
    polkit.enable = true;
  };

}
