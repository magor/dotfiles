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

  boot.loader.timeout = 3;

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

  # sched_ext: keep the compositor/input responsive under build load (EEVDF let
  # wakeups slip 12-15 ms). RT audio threads (FIFO) sit above sched_ext, unaffected.
  # flash won the A/B (2026-11-01) vs bpfland/lavd: tightest tail latency, same throughput.
  # "-I -1": flash defaults to a 32 us idle-resume QoS on every CPU, which blocks
  # C6/C8/C10 (170-230 us) and burns battery at idle.
  services.scx = {
    enable = true;
    scheduler = "scx_flash";
    extraArgs = [
      "-I"
      "-1"
    ];
  };

  # After resume the EC leaves the MMIO package PL1 at 12 W while DYTC's MSR PL1 says
  # 64 W; the lower one wins and starves CPU + iGPU (GPU stuck at 100-200 MHz, laggy UI).
  # The EC rewrites it some seconds after resume (a one-shot resume hook lost the race),
  # so keep mirroring the firmware's own MSR limit into MMIO, logging each correction.
  systemd.services.rapl-mmio-sync = {
    description = "Keep MMIO RAPL PL1 in sync with MSR PL1";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Restart = "always";
    script = ''
      msr=/sys/class/powercap/intel-rapl:0/constraint_0_power_limit_uw
      mmio=/sys/class/powercap/intel-rapl-mmio:0/constraint_0_power_limit_uw
      while true; do
        want=$(< $msr) have=$(< $mmio)
        if [ "$want" != "$have" ]; then
          echo "MMIO PL1 $((have / 1000000)) W -> $((want / 1000000)) W"
          echo "$want" > $mmio
        fi
        sleep 5
      done
    '';
  };

  # Don't sync on battery or over the phone hotspot.
  services.syncthing.gate = {
    enable = true;
    meteredConnections = [ "mg phone" ];
  };

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
