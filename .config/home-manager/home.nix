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
  home.packages = [
    # utils
    #pkgs.zsh # TODO config & problem wiht /etc/shells...
    pkgs.btop
    pkgs.lf # TODO config
    pkgs.htop
    pkgs.tree
    pkgs.fzf
    pkgs.ripgrep
    pkgs.iotop
    pkgs.nethogs
    pkgs.jq
    pkgs.lynx
    pkgs.ncdu

    # dev
    pkgs.git # TODO config
    pkgs.tig
    pkgs.python311Packages.ipython
    pkgs.jdk8
    pkgs.dbeaver
    pkgs.cntr
    pkgs.nerdfonts

    # de
    # TODO
    #pkgs.alacritty # TODO config
    pkgs.fuzzel
    pkgs.acpilight
    #pkgs.mako

    # web
    #pkgs.firefox # TODO
    pkgs.chromium

    # audio
    # TODO
    pkgs.helvum
    pkgs.pavucontrol

    # music
    pkgs.reaper

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
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
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
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
          set background=light
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}