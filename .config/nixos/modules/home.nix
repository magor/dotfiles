{ config, pkgs, lib, ... }:

{
  options.theme = lib.mkOption {
    type = lib.types.str;
    default = "dark";
  };

  imports = [
    ./neovim
  ];

  config = {
    specialisation = {
      light.configuration = {
        theme = "light";
        gtk.theme.name = lib.mkForce "Adwaita";
      };
      dark.configuration.config = {
        # this is default, no changes
      };
    };

    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "mirek";
    home.homeDirectory = "/home/mirek";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    #wayland.windowManager.hyprland.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      # utils
      zsh # TODO config
      lf # TODO config
      pistol
      btop
      htop
      tree
      fzf
      ripgrep
      iotop
      nethogs
      jq
      ncdu
      sshfs
      kmonad
      nh
      nix-inspect
      aria2
      unzip
      just
      yt-dlp

      # dev
      git # TODO config
      git-lfs
      tig
      lazygit
      difftastic
      python311Packages.ipython
      jdk8
      dbeaver-bin
      cntr

      # de
      # hyprland installed via system, workaround to 'DRI driver not from this Mesa build' problem
      grim
      slurp

      # audio - maybe not needed anymore?
      (writeShellScriptBin "nix-jack" ''
        exec /usr/bin/env \
          LD_LIBRARY_PATH=${pipewire.jack}/lib''${LD_LIBRARY_PATH:+:''${LD_LIBRARY_PATH}} \
          "''$@"
      '')

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/mirek/etc/profile.d/hm-session-vars.sh
    #

    programs = {
      nix-index = {
        enable = true;
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initExtra = ''
          # functions go here
        '';
        sessionVariables = {
          PISTOL_CHROMA_FORMATTER = "terminal256"; # fix colors in lf preview window
        };
        shellAliases = {
          c="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
          #W="watch";
          #t="tig --all";
          docker="sudo docker";
          #feh="feh --scale-down";
          k="kubectl";
          lg="lazygit";
          # kubectl="echo '!!! UNSECURE !!!' && kubectl --insecure-skip-tls-verify"
        };
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
        };
        oh-my-zsh = {
          enable = true;
          theme = "ys";
          plugins = [
            "fzf"
            "git"
            #"asdf"
            "colored-man-pages"
            #"gitignore"
            #"kubectl"
          ];
        };
      };
      alacritty = {
        enable = true;
        settings = {
          import = [
            "~/.config/alacritty/alacritty-theme/themes/gruvbox_${config.theme}.toml"
            "~/.config/alacritty/colors.toml"
          ];
          font.size = 11.0;
          window.opacity = 0.95;
        };
      };
    };

    services = {
      swaync = {
        enable = true;
      };
      syncthing = {
        enable = true;
        tray.enable = true;
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

    # https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1374497558
    gtk = {
      enable = true;
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };

    xdg.desktopEntries = {
      # wofi fails on this
      # try running via $ wofi --show drun -D drun-print_command=true
      # try with another runner or just map it to shortcut in hyprland
      screenshot = {
        name = "screenshot";
        exec = "grim -g \"\\$(slurp)\"";
        #exec = "grim -g \"\"";
        #exec = "grim -g \"\$\"";
        terminal = true;
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
