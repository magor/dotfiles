# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/57fd8160-0f56-4ac6-aae4-69cef927f244";
      fsType = "btrfs";
      options = [ "subvol=@root" "compress=zstd" "noatime" ];
    };

  fileSystems."/home/mirek/media" =
    { device = "/dev/disk/by-uuid/57fd8160-0f56-4ac6-aae4-69cef927f244";
      fsType = "btrfs";
      options = [ "subvol=@media" "compress=zstd" "noatime" ];
    };
  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/57fd8160-0f56-4ac6-aae4-69cef927f244";
      fsType = "btrfs";
      options = [ "subvol=@swap" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."btrfs-crypt".device = "/dev/disk/by-uuid/4bb7ea5a-b14b-447c-b5e4-56a5bc474bf1";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0D7A-50CF";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20f0u4u3u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
