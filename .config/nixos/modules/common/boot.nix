{ lib, ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = lib.mkDefault true;
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = lib.mkDefault true;
  };
}
