{ config, pkgs, ... }:

{
  # https://nixos.wiki/wiki/Tailscale
  services.tailscale = {
    enable = true;
  };
}
