# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./musnix
    ];
  musnix.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "CH-DC2HYZ2-CZ"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  powerManagement.enable = true;

  # List services that you want to enable:
  services = {
    # https://nixos.wiki/wiki/Laptop
    thermald.enable = true;
    tlp.enable = true;
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
    gnome.gnome-keyring.enable = true; # for sway
    blueman.enable = true;
    # Enable CUPS to print documents.
    # printing.enable = true;
    # Enable the OpenSSH daemon.
    # openssh.enable = true;
  };

  hardware = {
    opengl = {
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
          Experimental = true;
        };
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.mirek = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" "docker" "audio" "networkmanager" ];
     shell = pkgs.zsh;
     packages = with pkgs; [
       #firefox
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     lynx
     wget
     wineWowPackages.stable
     #wineWowPackages.waylandFull
     winetricks
   ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    hyprland.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {}; # workaround swaylock ignoring correct password to unlock
    # sound/pipewire: rtkit is optional but recommended
    rtkit.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
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

