{config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];

  systemd.tmpfiles.settings = {
    "10-looking-glass" = {
      "/dev/shm/looking-glass" = {
        f = {
          mode = "0660";
          user = "mirek";
          group = "kvm";
        };
      };
    };
  };
}
