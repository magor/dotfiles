{ ... }:

{
  # 1. Enable Podman container engine
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 2. Allow local discovery & Matter/mDNS traffic through the NixOS firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8123 # Home Assistant Web UI
      5580 # Matter Server web interface / pairing
    ];
    allowedUDPPorts = [
      5353 # mDNS (Avahi/Bonjour) - required for DIRIGERA discovery
      5540 # Matter commissionable discovery port
    ];
  };

  # 3. Home Assistant Core + Matter Server via OCI Containers
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      # Matter Server is required to communicate with DIRIGERA via Matter/Thread
      matter-server = {
        image = "ghcr.io/home-assistant-libs/python-matter-server:stable";
        extraOptions = [
          "--net=host"
          "--security-opt=apparmor=unconfined"
        ];
        volumes = [
          "/var/lib/matter-server:/data"
        ];
        environment = {
          TZ = "Europe/Prague";
        };
      };

      homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        extraOptions = [
          "--net=host"
          "--privileged"
        ];
        volumes = [
          "/var/lib/homeassistant:/config"
          "/run/dbus:/run/dbus:ro" # Allows HA to access host Bluetooth for Matter commissioning
        ];
        environment = {
          TZ = "Europe/Prague";
        };
        dependsOn = [ "matter-server" ];
      };
    };
  };

  # Ensure state directories exist with appropriate permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/homeassistant 0755 root root -"
    "d /var/lib/matter-server 0755 root root -"
  ];
}
