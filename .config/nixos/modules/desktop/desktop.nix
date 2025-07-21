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
    rose-pine-hyprcursor
    # for other cursor themes, check these:
    # https://sakshatshinde.github.io/hyprcursor-themes/
    # https://github.com/phisch/phinger-cursors
    # https://github.com/search?q=hyprcursor&type=repositories
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
    snapshot
    pinta
  ];

  services = {
    blueman.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit.enable = true;
  };
}
