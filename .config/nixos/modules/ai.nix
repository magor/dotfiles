{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.opencode
  ];
}
