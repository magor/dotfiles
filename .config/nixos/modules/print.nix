{ pkgs, ... }:

{
  # network printer discovery relies on avahi from modules/desktop
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
}
