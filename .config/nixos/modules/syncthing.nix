{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.syncthing.gate;

  # Stop syncthing on battery or on a metered link (phone hotspot); start it otherwise.
  gate = pkgs.writeShellApplication {
    name = "syncthing-gate";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      networkmanager
      systemd
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

      if [ "$on_ac" = 1 ] && [ "$metered" = 0 ]; then
        echo "on AC, unmetered: starting syncthing"
        systemctl start syncthing.service
      else
        echo "on_ac=$on_ac metered=$metered: stopping syncthing"
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
    }

    (lib.mkIf cfg.enable {
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
