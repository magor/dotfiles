{ config, pkgs, lib, ... }:

{
  options.theme = lib.mkOption {
    type = lib.types.str;
    default = "dark";
  };

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
      python311Packages.ipython
      jdk8
      dbeaver-bin
      cntr

      # de
      # TODO move to system conf?
      lxde.lxsession # polkit authentication agent
      fuzzel
      brightnessctl
      networkmanagerapplet
      #qt5.qtwayland
      #qt6.qtwayland
      gnome.nautilus
      corefonts
      wlsunset
      feh
      nwg-look
      wofi
      # hyprland installed via system, workaround to 'DRI driver not from this Mesa build' problem

      # audio
      # TODO
      pavucontrol
      spotify
      playerctl
      reaper
      vlc
      helvum
      qsynth
      fluidsynth
      soundfont-fluid
      carla
      helm
      drumgizmo
      hydrogen
      sfizz
      vital

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
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs = {
      neovim = {
        enable = true;
        vimAlias=true;
        vimdiffAlias=true;
        extraConfig = ''
          set number
          set cursorline
          set title
          set expandtab
          set tabstop=2
          set softtabstop=2
          set shiftwidth=2
          set ignorecase
          set smartcase
          " split navitation
          nnoremap <C-J> <C-W><C-J>
          nnoremap <C-K> <C-W><C-K>
          nnoremap <C-L> <C-W><C-L>
          nnoremap <C-H> <C-W><C-H>
          '';
        plugins = with pkgs.vimPlugins; [
          vim-airline
          {
            plugin = gruvbox-material;
            config = ''
              " Important!!
              if has('termguicolors')
                set termguicolors
              endif
              set background=${config.theme}
              let g:gruvbox_material_background = 'soft'
              let g:gruvbox_material_transparent_background = 1
              " For better performance - causes errors with file permissions
              "let g:gruvbox_material_better_performance = 1

              colorscheme gruvbox-material
              '';
          }

          {
            plugin = nvim-tree-lua;
            type = "lua";
            config = ''
              require("nvim-tree").setup()
              vim.keymap.set('n', '<C-n>', ':NvimTreeFindFileToggle<CR>')
              '';
          }

          #pkgs.vimPlugins.LazyVim
          #{
            #plugin = pkgs.vimPlugins.vim-startify;
            #config = "let g:startify_change_to_vcs_root = 0";
          #}
        ];
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

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
