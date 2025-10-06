{config, pkgs, home-manager, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mirek = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0PnFWKOhMUo2b38d5OnyaNjeIXoByAPnMhU09UPAoK mirek@gajdos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDoJjsFgqBmAWglQtlAAS09tTMENADdFIJa7ZDr+n0sh mirek@thinkpad"
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
    users.mirek = import ../home.nix;
  };
}
