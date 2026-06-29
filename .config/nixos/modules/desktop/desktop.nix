{
  pkgs,
  ...
}:

{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    chromium
    waybar
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
    hyprpolkitagent
    fuzzel
    brightnessctl
    networkmanagerapplet
    nautilus
    corefonts
    wlsunset
    feh
    nwg-look
    wofi
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
