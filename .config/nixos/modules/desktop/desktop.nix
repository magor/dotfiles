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
    sway
    lxde.lxsession # polkit authentication agent
    fuzzel
    brightnessctl
    networkmanagerapplet
    #qt5.qtwayland
    #qt6.qtwayland
    gnome.nautilus
    corefonts
    wlsunset
    feh
    nwg-look
    wofi
  ];

  services = {
    blueman.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit.enable = true;
  };
}
