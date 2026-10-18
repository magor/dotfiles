{ lib, pkgs, ... }:

{
  # device keys live in ~/.config/keybase and ~/.local/share/keybase (carried over from arch)
  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = "%h/keybase";
  };
  # PrivateTmp in a user unit runs it in a user namespace, where the setuid fusermount wrapper can't mount
  systemd.user.services.kbfs.serviceConfig.PrivateTmp = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    keybase
    keybase-gui
  ];
}
