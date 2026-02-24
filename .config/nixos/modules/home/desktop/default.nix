{ pkgs, config, ... }:

{
  config = {
    home.sessionVariables = {
      # https://nixos.wiki/wiki/Wayland#Electron_and_Chromium
      # https://nixos.wiki/wiki/Visual_Studio_Code#Wayland
      NIXOS_OZONE_WL = "1";
      OPENER = "xdg-open";
      XCURSOR_SIZE = "24";
      GDK_SCALE = "2"; # scale xwayland apps
    };

    #wayland.windowManager.hyprland.enable = true;
    xdg.configFile = {
      "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      "uwsm/env-hyprland".text = ''
        export HYPRCURSOR_THEME=rose-pine-hyprcursor
        export HYPRCURSOR_SIZE=28
      '';
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        #"mimetype1" = [ "default1.desktop" "default2.desktop" ];
        "image/*" = [ "feh.desktop" ];
        "image/jpeg" = [ "feh.desktop" ];
      };
      associations.removed = {
        "image/png" = [ "chromium-browser.desktop" ];
      };

      #defaultApplicationPackages = [ pkgs.feh ];
    };
    xdg.configFile."mimeapps.list".force = true;

    stylix.targets = {
      hyprpaper.enable = true;
      firefox.profileNames = [
        "default"
        "chyron"
      ];
    };

    home.packages = with pkgs; [
      # de
      # hyprland installed via system, workaround to 'DRI driver not from this Mesa build' problem
      grim
      slurp
      wl-clipboard

      zathura # pdf viewer

      anytype

      # dev
      dbeaver-bin
    ];

    programs = {
      alacritty = {
        enable = true;
      };
    };
    services = {
      udiskie = {
        enable = true;
        automount = true;
        notify = true;
        settings = {
          program_options = {
            file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
          };
        };
        tray = "always";
      };
      swaync = {
        enable = true;
      };
      syncthing = {
        enable = false; # service is managed by syncthing module on system level
        tray.enable = true;
      };
      kanshi = {
        enable = true;
        systemdTarget = "graphical-session.target";
        settings = [
          # can set defaults like this:
          #{ output.criteria = "eDP-1";
          #  output.scale = 1.066667;
          #}
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
            profile.outputs = [
              {
                criteria = "AU Optronics 0xFA9B Unknown"; # thinkpad screen
                scale = 1.5;
              }
              {
                criteria = "Dell Inc. DELL P3223QE 5KJ4G34";
                scale = 1.6;
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
        ];
      };
    };

    # Workaround for Failed to restart syncthingtray.service: Unit tray.target not found.
    # - https://github.com/nix-community/home-manager/issues/2064
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };
  };
}
