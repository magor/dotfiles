{config, pkgs, ... }:

{
  users.users.mirek.extraGroups = [ "docker" ];

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
    };
  };
}
