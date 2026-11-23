{ pkgs, ... }:

{
  config = {
    services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        # can set defaults like this:
        #{ output.criteria = "eDP-1";
        #  output.scale = 1.066667;
        #}
        {
          profile.name = "dell-laptop";
          profile.outputs = [
            {
              criteria = "LG Display 0x06CF Unknown"; # note the missing serial needs to be populated by the "Unknown" string
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "laptop";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.2;
            }
          ];
        }
        {
          profile.name = "thinkpad-home";
          # Positions are in logical px (mode / scale): S2725QS 2048x1152 | P3223QE 2048x1152,
          # laptop (1280x800) centred below the pair. Scale must divide the mode into whole
          # pixels (e.g. 1.8 on 4K is rejected by Hyprland; 1.6, 1.666667, 1.875, 2.0 work).
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL S2725QS 3JMP364";
              scale = 2.0;
              position = "0,0";
            }
            {
              criteria = "Dell Inc. DELL P3223QE 5KJ4G34";
              scale = 1.875;
              position = "1920,0";
            }
            {
              criteria = "AU Optronics 0xFA9B Unknown"; # thinkpad screen
              scale = 1.5;
              position = "1408,1152";
            }
          ];
          # Docked with the lid already closed (boot, hotplug): go straight to the panel-off profile.
          profile.exec = [
            "${pkgs.bash}/bin/sh -c '${pkgs.gnugrep}/bin/grep -qs closed /proc/acpi/button/lid/*/state && ${pkgs.kanshi}/bin/kanshictl switch thinkpad-home-lid-closed'"
          ];
        }
        {
          # Never auto-matched (thinkpad-home wins); reached via kanshictl switch from the
          # lid binds in hypr/binds.conf or the exec above.
          profile.name = "thinkpad-home-lid-closed";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL S2725QS 3JMP364";
              scale = 1.875;
              position = "0,0";
            }
            {
              criteria = "Dell Inc. DELL P3223QE 5KJ4G34";
              scale = 1.875;
              position = "2048,0";
            }
            {
              criteria = "AU Optronics 0xFA9B Unknown";
              status = "disable";
            }
          ];
        }
        {
          profile.name = "dell-work";
          profile.outputs = [
            {
              criteria = "LG Display 0x06CF Unknown"; # note the missing serial needs to be populated by the "Unknown" string
              scale = 1.333333;
            }
            {
              criteria = "Dell Inc. DELL P2423 JWL7VJ3";
            }
            {
              criteria = "Dell Inc. DELL P2423 C1WRVJ3";
            }
          ];
        }
        {
          profile.name = "shathak";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL P3223QE 5KJ4G34";
              scale = 1.6;
            }
          ];
        }
      ];
    };
  };
}
