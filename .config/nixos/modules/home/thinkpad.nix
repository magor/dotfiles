# ThinkPad laptop: idle lock/screen/suspend via Noctalia; keyboard backlight via hypridle.
{
  config.programs.noctalia.settings = {
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
