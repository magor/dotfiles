{config, pkgs, ... }:

{
  powerManagement.enable = true;

  # List services that you want to enable:
  services = {
    # https://nixos.wiki/wiki/Laptop
    thermald.enable = true;
    tlp.enable = true;
    fwupd.enable = true;
    # Enable CUPS to print documents.
    # printing.enable = true;
  };
}
