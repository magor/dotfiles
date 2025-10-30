{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tailscalesd # prometheus service discovery for tailscale
  ];

  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    globalConfig.scrape_interval = "10s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "tailscale-node-exporter";
        http_sd_configs = [
          {
            url = "http://localhost:9242/";
          }
        ];
        relabel_configs = [
          {
            source_labels = [ "__meta_tailscale_device_hostname" ];
            target_label = "tailscale_hostname";
          }
          {
            source_labels = [ "__meta_tailscale_device_name" ];
            target_label = "tailscale_name";
          }
          {
            source_labels = [ "__address__" ];
            # regex = "(.*)"; # default
            replacement = "$1:9000";
            target_label = "__address__";
          }
        ];
      }
    ];
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

  systemd.services."tailscalesd" = {
    description = "Prometheus Service Discovery for Tailscale";
    after = [
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.tailscalesd}/bin/tailscalesd -localapi -address 127.0.0.1:9242";
    restartIfChanged = true;
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
