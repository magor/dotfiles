{config, pkgs, inputs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # needed for flakes
    tree
    lynx
    wget
    wineWowPackages.stable
    #wineWowPackages.waylandFull
    winetricks
    # nix tools
    nvd
    gparted
    inputs.helix.packages."${pkgs.system}".helix
  ];

  programs = {
    firefox.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };
}
