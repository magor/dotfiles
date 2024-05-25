{ config, pkgs, ... }:

{
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # utils
    zsh # TODO config
    lf # TODO config
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

    # dev
    git # TODO config
    git-lfs
    tig
    python311Packages.ipython
    jdk8
    dbeaver
    cntr

    # de
    # TODO move to system conf?
    sway
    swaylock
    swayidle
    lxde.lxsession # polkit authentication agent
    alacritty # TODO config
    fuzzel
    brightnessctl
    mako
    waybar
    networkmanagerapplet
    #qt5.qtwayland
    #qt6.qtwayland
    gnome.nautilus
    corefonts
    wlsunset

    # hyprland
    wofi
    hypridle
    hyprcursor
    xdg-desktop-portal-hyprland

    # audio
    # TODO
    pavucontrol
    spotify
    reaper
    helvum
    qsynth
    fluidsynth
    soundfont-fluid
    carla
    helm
    drumgizmo
    hydrogen

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

  programs.neovim = {
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
          set background=dark
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
          vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')
          '';
      }

      #pkgs.vimPlugins.LazyVim
      #{
        #plugin = pkgs.vimPlugins.vim-startify;
        #config = "let g:startify_change_to_vcs_root = 0";
      #}
    ];
  };

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
  # Workaround for Failed to restart syncthingtray.service: Unit tray.target not found.
  # - https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
