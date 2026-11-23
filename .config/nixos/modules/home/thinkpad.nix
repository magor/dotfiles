# ThinkPad laptop: idle lock/screen/suspend and display brightness (incl. DDC/CI) via Noctalia;
# keyboard backlight via hypridle.
{
  config.programs.noctalia.settings = {
    brightness = {
      enable_ddcutil = true;
      minimum_brightness = 0.01; # keep the panel from going fully black
    };
    idle = {
      behavior_order = [
        "lock"
        "screen-off"
        "suspend"
      ];
      pre_action_fade_seconds = 0;
      behavior = {
        lock = {
          action = "lock";
          timeout = 300;
          enabled = true;
        };
        "screen-off" = {
          action = "screen_off";
          timeout = 900;
          enabled = true;
        };
        suspend = {
          action = "lock_and_suspend";
          timeout = 1800;
          enabled = true;
        };
      };
    };
  };
}
