{config, pkgs, ... }:

{
  powerManagement.enable = true;

  # List services that you want to enable:
  services = {
    # https://nixos.wiki/wiki/Laptop
    thermald.enable = true;
    tlp.enable = true;
    fwupd.enable = true;
    # Enable CUPS to print documents.
    # printing.enable = true;
    # Enable the OpenSSH daemon.
    # openssh.enable = true;
    netdata = {
      enable = true;

      config = {
        global = {
          # uncomment to reduce memory to 32 MB
          #"page cache size" = 32;

          # update interval
          "update every" = 15;
        };
        ml = {
          # enable machine learning
          "enabled" = "yes";
        };
      };
    };
  };
}
