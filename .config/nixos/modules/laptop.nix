{config, pkgs, ... }:

{
  # https://nixos.wiki/wiki/Laptop

  powerManagement.enable = true;

  services = {
    thermald.enable = true;
    fwupd.enable = true;
    tuned.enable = true;
  };
}
