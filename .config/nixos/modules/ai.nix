{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.opencode
    unstable.claude-code
  ];
}
