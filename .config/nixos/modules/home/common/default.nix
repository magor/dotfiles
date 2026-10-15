{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./neovim
    ./cleanup-tmp.nix
  ];

  config = {

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
    home.stateVersion = "26.05";

    stylix.targets = {
      neovim.transparentBackground = {
        main = true;
      };
      # QT_STYLE_OVERRIDE=kvantum
      # https://github.com/nix-community/stylix/issues/835
      # https://github.com/nix-community/stylix/issues/1092
      qt.enable = false;
    };

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      # utils
      lf # TODO config
      file
      pistol
      btop
      htop
      fzf
      ripgrep
      iotop
      nethogs
      jq
      ncdu
      nh
      nix-inspect
      aria2
      unzip
      just
      tig

      byobu
      tmux
      # dev tools live in modules/home/dev

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

        initContent = ''
          # functions go here
        '';
        sessionVariables = {
          PISTOL_CHROMA_FORMATTER = "terminal256"; # fix colors in lf preview window
        };
        shellAliases = {
          c = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
          #W="watch";
          #t="tig --all";
          docker = "sudo docker";
          #feh="feh --scale-down";
          k = "kubectl";
          lg = "lazygit";
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
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      lazygit = {
        enable = true;
        settings = {
          git = {
            pagers = [
              {
                colorArg = "always";
                pager = "delta --paging=never --syntax-theme base16-256 -s";
              }
            ];
          };
        };
      };
      git = {
        enable = true;
        lfs.enable = true;
      };
      gh = {
        enable = true;
        # git credential helper for github.com / gist.github.com, path kept current by HM
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "ssh"; # match the existing ssh remotes (default: https)
          aliases.co = "pr checkout";
        };
      };
      delta = {
        enable = true;
        enableGitIntegration = true;
      };
    };

    xdg.userDirs = {
      enable = true;
      setSessionVariables = true;
      documents = "${config.home.homeDirectory}/doc";
      download = "${config.home.homeDirectory}/dl";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pics";
      videos = "${config.home.homeDirectory}/media/videos";
      desktop = null; # set to null or home to disable
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
