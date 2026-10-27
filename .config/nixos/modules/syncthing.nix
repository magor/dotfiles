{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.syncthing.gate;

  # Exit 0 when syncthing may run: on AC and not on a metered link (phone hotspot).
  check = pkgs.writeShellApplication {
    name = "syncthing-gate-check";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      networkmanager
    ];
    text = ''
      on_ac=1
      if [ -r /sys/class/power_supply/AC/online ]; then
        on_ac=$(cat /sys/class/power_supply/AC/online)
      fi

      metered=0
      # "yes" or "yes (guessed)" on any device; Android hotspots usually advertise this.
      if nmcli -t -f GENERAL.METERED dev show 2>/dev/null | grep -q '^GENERAL.METERED:yes'; then
        metered=1
      fi
      always_metered=(${lib.escapeShellArgs cfg.meteredConnections})
      while IFS= read -r name; do
        for m in "''${always_metered[@]}"; do
          [ "$name" = "$m" ] && metered=1
        done
      done < <(nmcli -t -f NAME con show --active 2>/dev/null)

      echo "on_ac=$on_ac metered=$metered"
      [ "$on_ac" = 1 ] && [ "$metered" = 0 ]
    '';
  };

  # Start or stop syncthing to match the current power/network state.
  gate = pkgs.writeShellApplication {
    name = "syncthing-gate";
    runtimeInputs = [
      check
      pkgs.systemd
    ];
    text = ''
      if syncthing-gate-check; then
        echo "starting syncthing"
        systemctl start syncthing.service
      else
        echo "stopping syncthing"
        systemctl stop syncthing.service
      fi
    '';
  };
in
{
  options.services.syncthing.gate = {
    enable = lib.mkEnableOption "stopping syncthing on battery or metered connections";
    meteredConnections = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "NetworkManager connection names always treated as metered.";
    };
  };

  config = lib.mkMerge [
    {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        user = "mirek";
        dataDir = "/home/mirek/sync";

        # Optional: set GUI credentials

        # declarative settings fails for now
        # see https://github.com/NixOS/nixpkgs/issues/245121
        #settings.devices = {
        #    "nixodeos" = { id = "..."; };
        #};
      };

      # https://wiki.nixos.org/wiki/Syncthing#Disable_default_sync_folder
      systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

      # .stignore is not synced, so every peer needs its own copy.
      home-manager.users.mirek.home.file."doc/.stignore".text = ''
        /.git
        ftp-service/data/etc/pureftpd.passwd
        ftp-service/data/etc/pureftpd.pdb
        .direnv
      '';
    }

    (lib.mkIf cfg.enable {
      # Skip (rather than fail) any start on battery or metered link: boot, switch, manual start.
      systemd.services.syncthing.serviceConfig.ExecCondition = lib.getExe check;

      systemd.services.syncthing-gate = {
        description = "Stop syncthing on battery or metered network";
        after = [
          "syncthing.service"
          "NetworkManager.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe gate;
        };
      };

      # Re-evaluate on AC plug/unplug.
      services.udev.extraRules = ''
        SUBSYSTEM=="power_supply", KERNEL=="AC", ACTION=="change", RUN+="${pkgs.systemd}/bin/systemctl start --no-block syncthing-gate.service"
      '';

      # Re-evaluate whenever a connection goes up or down.
      networking.networkmanager.dispatcherScripts = [
        {
          type = "basic";
          source = pkgs.writeText "syncthing-gate-dispatcher" ''
            case "$2" in
              up|down|connectivity-change)
                ${pkgs.systemd}/bin/systemctl start --no-block syncthing-gate.service ;;
            esac
          '';
        }
      ];
    })
  ];
}
