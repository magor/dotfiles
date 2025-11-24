{ ... }:

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
