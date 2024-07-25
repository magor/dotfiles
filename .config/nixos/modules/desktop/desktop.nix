{config, pkgs, ... }:

{
  programs = {
    hyprland.enable = true;
    firefox.enable = true;
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
