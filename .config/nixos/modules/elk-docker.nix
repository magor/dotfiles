# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."elk-elasticsearch" = {
    image = "docker-elk-elasticsearch";
    environment = {
      "ELASTIC_PASSWORD" = "changeme";
      "ES_JAVA_OPTS" = "-Xms512m -Xmx512m";
      "discovery.type" = "single-node";
      "node.name" = "elasticsearch";
    };
    volumes = [
      "/home/mirek/dev/github/deviantony/docker-elk/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro,Z"
      "elk_elasticsearch:/usr/share/elasticsearch/data:rw,Z"
    ];
    ports = [
      "9200:9200/tcp"
      "9300:9300/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=elasticsearch"
      "--network=elk_elk"
    ];
  };
  systemd.services."docker-elk-elasticsearch" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-elk_elk.service"
      "docker-volume-elk_elasticsearch.service"
    ];
    requires = [
      "docker-network-elk_elk.service"
      "docker-volume-elk_elasticsearch.service"
    ];
    partOf = [
      "docker-compose-elk-root.target"
    ];
    wantedBy = [
      "docker-compose-elk-root.target"
    ];
  };
  virtualisation.oci-containers.containers."elk-kibana" = {
    image = "docker-elk-kibana";
    environment = {
      "KIBANA_SYSTEM_PASSWORD" = "changeme";
    };
    volumes = [
      "/home/mirek/dev/github/deviantony/docker-elk/kibana/config/kibana.yml:/usr/share/kibana/config/kibana.yml:ro,Z"
    ];
    ports = [
      "5601:5601/tcp"
    ];
    dependsOn = [
      "elk-elasticsearch"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=kibana"
      "--network=elk_elk"
    ];
  };
  systemd.services."docker-elk-kibana" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-elk_elk.service"
    ];
    requires = [
      "docker-network-elk_elk.service"
    ];
    partOf = [
      "docker-compose-elk-root.target"
    ];
    wantedBy = [
      "docker-compose-elk-root.target"
    ];
  };
  virtualisation.oci-containers.containers."elk-logstash" = {
    image = "docker-elk-logstash";
    environment = {
      "LOGSTASH_INTERNAL_PASSWORD" = "changeme";
      "LS_JAVA_OPTS" = "-Xms256m -Xmx256m";
    };
    volumes = [
      "/home/mirek/dev/github/deviantony/docker-elk/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro,Z"
      "/home/mirek/dev/github/deviantony/docker-elk/logstash/pipeline:/usr/share/logstash/pipeline:ro,Z"
    ];
    ports = [
      "5044:5044/tcp"
      "50000:50000/tcp"
      "50000:50000/udp"
      "9600:9600/tcp"
    ];
    dependsOn = [
      "elk-elasticsearch"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=logstash"
      "--network=elk_elk"
    ];
  };
  systemd.services."docker-elk-logstash" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-elk_elk.service"
    ];
    requires = [
      "docker-network-elk_elk.service"
    ];
    partOf = [
      "docker-compose-elk-root.target"
    ];
    wantedBy = [
      "docker-compose-elk-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-elk_elk" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f elk_elk";
    };
    script = ''
      docker network inspect elk_elk || docker network create elk_elk --driver=bridge
    '';
    partOf = [ "docker-compose-elk-root.target" ];
    wantedBy = [ "docker-compose-elk-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-elk_elasticsearch" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect elk_elasticsearch || docker volume create elk_elasticsearch
    '';
    partOf = [ "docker-compose-elk-root.target" ];
    wantedBy = [ "docker-compose-elk-root.target" ];
  };

  # Builds
  systemd.services."docker-build-elk-elasticsearch" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd /home/mirek/dev/github/deviantony/docker-elk/elasticsearch
      docker build -t compose2nix/elk-elasticsearch --build-arg ELASTIC_VERSION= .
    '';
  };
  systemd.services."docker-build-elk-kibana" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd /home/mirek/dev/github/deviantony/docker-elk/kibana
      docker build -t compose2nix/elk-kibana --build-arg ELASTIC_VERSION= .
    '';
  };
  systemd.services."docker-build-elk-logstash" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd /home/mirek/dev/github/deviantony/docker-elk/logstash
      docker build -t compose2nix/elk-logstash --build-arg ELASTIC_VERSION= .
    '';
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-elk-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
