{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "homes";

  # 24/7 ThinkCentre M920q Tiny (i5-9500T): cool/quiet defaults + durability
  powerManagement.cpuFreqGovernor = "powersave";

  zramSwap.enable = true;

  services = {
    fwupd.enable = true;
    thermald.enable = true;

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };

  # Prefer stable WiFi for HA/Matter until ethernet is used
  networking.networkmanager.wifi.powersave = false;

  environment.systemPackages = with pkgs; [
    lm_sensors
    smartmontools
    powertop
  ];

  system.stateVersion = "26.05";
}
