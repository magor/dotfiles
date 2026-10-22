{config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    # tailscaled in openresolv mode snapshots upstream DNS at boot, before NM's
    # DHCP lease arrives -> MagicDNS has no upstreams and SERVFAILs everything.
    # With resolved, NM and tailscale each set per-link DNS independently.
    networkmanager.dns = "systemd-resolved";
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  services.resolved.enable = true;

  users.users.mirek.extraGroups = [ "networkmanager" ];
}
