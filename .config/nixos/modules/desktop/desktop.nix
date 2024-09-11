{config, pkgs, inputs, ... }:

let pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}; in

{
  # https://wiki.hyprland.org/Nix/Cachix/
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  hardware.opengl = {
    package = pkgs-unstable.mesa.drivers;

    # if you also want 32-bit support (e.g for Steam)
    driSupport32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };

  programs = {
    hyprland = {
      enable = true;
      # using flake/dev version
      # see https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    waybar
    hypridle
    hyprpaper
    hyprcursor
    hyprlock
    xdg-desktop-portal-hyprland
    alacritty
    termite
  ];

  services = {
    blueman.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit.enable = true;
  };
}
