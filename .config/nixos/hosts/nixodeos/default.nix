# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda"; # or "nodev" for efi only
  };

  networking = {
    hostName = "nixodeos"; # Define your hostname.
    interfaces = {
      ens18 = {
        ipv4.addresses = [{
          address = "46.36.38.241";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2a02:25b0:aaaa:5456::";
          prefixLength = 64;
        }];
      };
    };
    defaultGateway = "46.36.38.1";
    defaultGateway6 = {
      address = "2a02:25b0:aaaa::1";
      interface = "ens18";
    };
    nameservers = [ "8.8.8.8" "8.8.4.4"];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils # needed for samba mount
  ];

  # https://nixos.wiki/wiki/Syncthing
  services.syncthing = {
    enable = true;
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

