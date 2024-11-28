{config, pkgs, inputs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # needed for flakes
    tree
    wget
    # nix tools
    nvd
  ];

  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  # Generate the manual page index caches.
  # This allows searching for a page or keyword using utilities like apropos(1) and the -k option of man(1).
  documentation.man.generateCaches = true;
}
