{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

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

  # Share internet via Ethernet (NetworkManager ipv4.method = shared).
  # NM enables per-interface forwarding itself; only open DHCP + DNS to clients
  # so Matter (5580), harmonia and node_exporter stay closed on eno2.
  networking.firewall.interfaces.eno2 = {
    allowedUDPPorts = [
      53 # DNS (NM dnsmasq)
      67 # DHCP
    ];
    allowedTCPPorts = [ 53 ];
  };

  # Host BlueZ for Home Assistant (container talks to it via /run/dbus)
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    smartmontools
    powertop
  ];

  system.stateVersion = "26.05";
}
