{ ... }:

{
  # https://nixos.wiki/wiki/Laptop
  imports = [
    ./hardware/bluetooth.nix
    ./hardware/intel-graphics.nix
  ];

  powerManagement.enable = true;

  services = {
    thermald.enable = true;
    fwupd.enable = true;
    tuned.enable = true;
  };
}
