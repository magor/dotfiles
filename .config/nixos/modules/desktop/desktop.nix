{config, pkgs, inputs, ... }:

{
  programs = {
    hyprland.enable = true;
    hyprland.withUWSM  = true;
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    unstable.waybar # https://github.com/Alexays/Waybar/issues/3042
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
    nautilus
    corefonts
    wlsunset
    feh
    nwg-look
    wofi
    inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
  ];

  services = {
    blueman.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit.enable = true;
  };
}
