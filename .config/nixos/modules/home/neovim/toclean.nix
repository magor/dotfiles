{ pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # to be cleaned

      # plugins from nixpkgs go in here.
      # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins

      # lazy loading
      #lazy-nvim # TODO configure

      # nvim-cmp (autocompletion) and extensions
      lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
      cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
      cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
      cmp-cmdline-history # cmp command line history suggestions

      # git integration plugins
      diffview-nvim # https://github.com/sindrets/diffview.nvim/
      neogit # https://github.com/TimUntersberger/neogit/
      gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
      vim-fugitive # https://github.com/tpope/vim-fugitive/

      # telescope and extensions
      #dressing-nvim
      # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim

      # navigation/editing enhancement plugins
      #vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
      #nvim-surround # https://github.com/kylechui/nvim-surround/
      nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
      nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/

      # navigation
      #eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
      #flash-nvim # TODO configure

    ];

    extraLuaConfig = # lua
      ''
        -----------------
      '';
  };
}
