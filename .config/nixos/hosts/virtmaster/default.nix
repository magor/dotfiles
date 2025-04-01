# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # networking
  networking = {
    hostName = "virtmaster"; # Define your hostname.
    networkmanager.enable = true;
  };
  
  # ssh reverse tunnel
  systemd.services.sshReverseTunnel = {
    # inspired by https://blog.stigok.com/2018/04/22/self-healing-reverse-ssh-systemd-service.html
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];
    description = "Self healing reverse ssh tunnel using Mirek's nixodeos server";
    serviceConfig = {
      Type = "exec";
      ExecStart = ''${pkgs.openssh}/bin/ssh -vvv -g -N -T -o "ServerAliveInterval 10" -o "ExitOnForwardFailure yes" -R 4002:localhost:22 chyron@46.36.38.241'';
      Restart = "always";
      RestartSec = "5s";
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.mirek = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH9fApHPV0yOZRcq/v3ExbPpsi3Us5c4OgG2ykbSS+B6 mirek@nixodeos"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
