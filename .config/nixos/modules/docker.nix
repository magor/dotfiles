{ ... }:

{
  users.users.mirek.extraGroups = [ "docker" ];

  virtualisation = {
    docker.enable = true;
  };
}
