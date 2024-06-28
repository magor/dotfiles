{config, pkgs, ... }:

{
  programs = {
    hyprland.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  services = {
    gnome.gnome-keyring.enable = true; # for sway
    blueman.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {}; # workaround swaylock ignoring correct password to unlock
  };

}
