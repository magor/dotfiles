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
    unstable.waybar # https://github.com/Alexays/Waybar/issues/3042
    #hypridle
    unstable.hypridle # need 0.1.7 for <listener:ignore_inhibit>
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
    firefox-nightly
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
