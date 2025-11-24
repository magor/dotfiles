{ pkgs, ... }:

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

  # Generate the manual page index caches.
  # This allows searching for a page or keyword using utilities like apropos(1) and the -k option of man(1).
  # disable if slow
  documentation.man.generateCaches = true;
}
