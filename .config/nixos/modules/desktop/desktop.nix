{
  pkgs,
  pkgs-unstable,
  firefox,
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
    pkgs-unstable.waybar # https://github.com/Alexays/Waybar/issues/3042
    #hypridle
    pkgs-unstable.hypridle # need 0.1.7 for <listener:ignore_inhibit>
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
    firefox.packages.${pkgs.system}.firefox-nightly-bin
    snapshot
    pinta
  ];

  # https://nixos.wiki/wiki/Wayland#Electron_and_Chromium
  # https://nixos.wiki/wiki/Visual_Studio_Code#Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services = {
    blueman.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit.enable = true;
  };
}
