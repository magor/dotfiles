{ config, pkgs, ... }:

{
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  services.prometheus = {
    exporters.node = {
      enable = true;
      port = 9000;
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
      enabledCollectors = [ "systemd" ];
      # /nix/store/zgsw0yx18v10xa58psanfabmg95nl2bb-node_exporter-1.8.1/bin/node_exporter  --help
      extraFlags = [
        "--collector.ethtool"
        "--collector.softirqs"
        "--collector.tcpstat"
        "--collector.wifi"
      ];
    };
  };

  # node exporter listens by default on all interfaces, but default nixos firewall blocks it
  # this will allow incoming connection over tailscale
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 9000 ];
}
