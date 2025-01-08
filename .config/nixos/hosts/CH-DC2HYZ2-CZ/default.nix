# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/3110#note_1977282
  boot.kernelParams = [ "intel_iommu=on,igfx_off" ];

  # fix hdmi bitrate on philips tv (no sound with default S32LE)
  # https://wiki.archlinux.org/title/PipeWire#Changing_the_sample_rate
  # https://nixos.wiki/wiki/PipeWire#Controlling_the_ALSA_devices
  # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/3016#note_2031727
  # https://www.reddit.com/r/voidlinux/comments/rbq4ns/sof_firmware_help/
  # https://bbs.archlinux.org/viewtopic.php?id=290824
  services.pipewire.wireplumber.extraConfig = { 
    "51-alsa-hdmi" = {
      "monitor.alsa.rules" = [
        {
          matches = [
              # must use complete name, glob matching doesn't work??
            {"node.name" = "alsa_output.pci-0000_00_1f.3.hdmi-stereo";}
          ];

          actions = {
            update-props = {
              "node.nick" = "Philips TV HDMI S16 shit";
              "audio.format" = "S16";
            };
          };
        }
      ];
    };
    "log-level-debug" = {
      "context.properties" = {
        # Output Debug log messages as opposed to only the default level (Notice)
        #"log.level" = "D";
      };
    };
  };

  networking = {
    hostName = "CH-DC2HYZ2-CZ"; # Define your hostname.
  };

  users.users.mirek.extraGroups = [ "video" ];

  services.teamviewer.enable = true; # client doesn't work without running service :(

  hardware = {
    graphics = {
      enable = true;
      # https://nixos.wiki/wiki/Accelerated_Video_Playback
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        #intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
    };
    # bluetooth
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          # https://nixos.wiki/wiki/Bluetooth#Showing_battery_charge_of_bluetooth_devices
          Experimental = true;
        };
      };
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Do NOT change this value
  # unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
