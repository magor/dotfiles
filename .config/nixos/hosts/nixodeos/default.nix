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
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
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

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mirek = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWAuggWw9pRBmkrfYevThkgWZnif2ykMW7U47FfGvgk mirek@CH-DC2HYZ2-CZ"
    ];
    packages = with pkgs; [
      firefox
      tree
      git
      lf
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    cifs-utils
    git
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set number
        set cursorline
        set title
        set expandtab
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
        " split navitation
        nnoremap <C-J> <C-W><C-J>
        nnoremap <C-K> <C-W><C-K>
        nnoremap <C-L> <C-W><C-L>
        nnoremap <C-H> <C-W><C-H>
      '';
      #packages.myVimPackage = with pkgs.vimPlugins; {
      #  start = [ vim-airline nvim-tree-lua ];
      #};
    };
  };

  # List services that you want to enable:
  # https://nixos.wiki/wiki/Syncthing
  services.syncthing = {
    enable = true;
    #user = "syncthing";
    #dataDir = "/home/syncthing/storage";    # Default folder for new synced folders
    #configDir = "/home/syncthing/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

