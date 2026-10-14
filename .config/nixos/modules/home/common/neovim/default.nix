{
  pkgs,
  lib,
  ...
}:

{
  # TODO
  # - fix bradcrumbs (lspsaga) https://nvimdev.github.io/lspsaga/breadcrumbs/
  # - fix deprecation warning (use vim.diagnostic.config instead of sign_define) https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.status()
  # - use italics (comments etc)
  # check `:help lspconfig-all`

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # LSP, completion and lspsaga live in modules/home/dev/neovim
  imports = [
    ./treesitter.nix
    ./ui.nix
    #./toclean.nix
  ];

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    vimAlias = true;
    vimdiffAlias = true;

    initLua = lib.mkOrder 1600 # lua
      ''
        local options = {
          updatetime = 50, -- faster completion (4000ms default)
          scrolloff = 5,
        }

        for k, v in pairs(options) do
          vim.opt[k] = v
        end
      '';

    extraConfig = # vim
      ''
        set number relativenumber
        set cursorline
        set title
        set expandtab
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
        set ignorecase
        set smartcase

        "nnoremap " " <NOP>
        let mapleader=" "

        nnoremap <leader>n <cmd>set relativenumber!<cr>

        "TSEnable highlight

        " split navitation
        nnoremap <C-J> <C-W><C-J>
        nnoremap <C-K> <C-W><C-K>
        nnoremap <C-L> <C-W><C-L>
        nnoremap <C-H> <C-W><C-H>

        " buffer navigation
        "nnoremap <A-h> <cmd>bprev<cr>
        "nnoremap <A-l> <cmd>bnext<cr>
        nnoremap <A-h> <cmd>BufferLineCyclePrev<cr>
        nnoremap <A-l> <cmd>BufferLineCycleNext<cr>
        nnoremap <A-H> <cmd>BufferLineMovePrev<cr>
        nnoremap <A-L> <cmd>BufferLineMoveNext<cr>
        "nnoremap <A-Del> <cmd>bdelete<cr> <bar> <cmd>BufferLineCyclePrev<cr>
        nnoremap <A-Del> <cmd>bdelete<cr> <bar> <cmd>bdelete<cr>

        " Find files using Telescope command-line sugar.
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>b <cmd>Telescope buffers<cr>
        nnoremap <leader>fh <cmd>Telescope help_tags<cr>
      '';

    plugins = with pkgs.vimPlugins; [
      # see https://search.nixos.org/packages?channel=25.05&query=vimPlugins. for more plugins

      # fuzzy finder
      telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
      telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim

      # Useful utilities
      #nvim-unception # Prevent nested neovim sessions | nvim-unception

      # libraries that other plugins depend on
      sqlite-lua
      plenary-nvim
      nvim-web-devicons
      vim-repeat

      # bleeding-edge plugins from flake inputs
      # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
      # ^ bleeding-edge plugins from flake inputs

      #pkgs.vimPlugins.LazyVim
      #{
      #plugin = pkgs.vimPlugins.vim-startify;
      #config = "let g:startify_change_to_vcs_root = 0";
      #}
    ];
  };
}
