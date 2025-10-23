{ config, pkgs, ... }:

{
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
  };

  # https://nixos.wiki/wiki/Grafana
  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        #domain = "your.domain";
        domain = "localhost";
        #root_url = "https://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
        serve_from_sub_path = true;
      };
    };
  };

  systemd.services."tailscale-serve-grafana" = {
    description = "Expose Grafana to Tailnet via Tailscale Serve";
    after = [
      "tailscale.service"
      "grafana.service"
    ];
    wantedBy = [ "multi-user.target" ];
    #serviceConfig.ExecStart = "${pkgs.tailscale}/bin/tailscale serve https 3000";
    serviceConfig.ExecStart = "${pkgs.tailscale}/bin/tailscale serve 3000";
    restartIfChanged = true;
  };
}
