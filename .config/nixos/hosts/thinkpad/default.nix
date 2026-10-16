{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    fprintd.enable = true; # fingerprint reader
    # Exits on start: "Thermald can't run on this platform" (Lenovo DYTC owns thermals).
    thermald.enable = lib.mkForce false;
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
  };

  # Pass TRIM through LUKS, otherwise fstrim.timer is a no-op.
  boot.initrd.luks.devices."luks-97ec0d64-8f62-4f0f-a24b-413f572311de" = {
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/".options = [
    "compress=zstd:1"
    "noatime"
  ];

  zramSwap.enable = true;

  # musnix forces "performance"; leave the governor to intel_pstate + tuned (EPP).
  powerManagement.cpuFreqGovernor = lib.mkForce null;

  # Cap charging at 80% to slow battery wear.
  systemd.tmpfiles.rules = [
    "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
  ];

  networking = {
    hostName = "thinkpad";
  };

  users.users.mirek.extraGroups = [ "video" ];

  # Force the system to use the Intel Media Driver (iHD)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.graphics.extraPackages = with pkgs; [
    vpl-gpu-rt # For newer QSV (Quick Sync Video) support
  ];

  services.journald.extraConfig = ''
    SystemMaxUse=300M
  '';

  # Do NOT change this value
  # unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
