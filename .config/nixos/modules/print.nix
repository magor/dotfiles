{ pkgs, ... }:

{
  # network printer discovery relies on avahi from modules/desktop;
  # cups-browsed runs via services.printing.browsed (enabled by default with avahi)
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
    ];
  };
}
