{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mirek = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQQMpBbUEUPaUyggZcxW2X8dMDDnfQmg0BQK567OQwr mirek@gajdos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDoJjsFgqBmAWglQtlAAS09tTMENADdFIJa7ZDr+n0sh mirek@thinkpad"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7G/DhE3QfGMtz1faaa24Eb0HRR6uEpYPkgB6oVl7dS mirek@shathak"
    ];
    packages = with pkgs; [
      lf
      fzf
      ripgrep
      pistol
    ];
  };

  programs = {
    zsh.enable = true;
    ssh.startAgent = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mirek = import ../home;
  };
}
