{config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/Storage_optimization
  nix.optimise.automatic = true;

  # needed for home-manager module
  programs.dconf.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.configurationLimit = 20;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
