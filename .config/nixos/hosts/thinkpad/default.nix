{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    fprintd.enable = true; # fingerprint reader
    throttled.enable = true; # fix intel cpu throttling
  };

  networking = {
    hostName = "thinkpad";
  };

  users.users.mirek.extraGroups = [ "video" ];

  # Force the system to use the Intel Media Driver (iHD)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.graphics.extraPackages = with pkgs; [
    vpl-gpu-rt # For newer QSV (Quick Sync Video) support
    intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
  ];

  # Do NOT change this value
  # unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
