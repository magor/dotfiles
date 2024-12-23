{config, pkgs, home-manager, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mirek = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWAuggWw9pRBmkrfYevThkgWZnif2ykMW7U47FfGvgk mirek@CH-DC2HYZ2-CZ"
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
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mirek = import ../home.nix;
  };
}
