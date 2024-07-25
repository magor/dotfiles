{config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  users.users.mirek.extraGroups = [ "networkmanager" ];
}
