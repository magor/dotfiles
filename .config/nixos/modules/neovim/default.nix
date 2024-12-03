{
  config,
  lib,
  pkgs,
  ...
}:

{
      home.sessionVariables = {
        EDITOR = "nvim";
      };

      home.packages = with pkgs; [
        # language servers, etc.
        lua-language-server
        nil # nix LSP
      ];

      programs.neovim = {
        enable = true;
        vimAlias=true;
        vimdiffAlias=true;
        extraPackages = [ pkgs.gcc ];
        extraLuaConfig = ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true
            }
          }
        '';

        extraConfig = ''
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

          " Find files using Telescope command-line sugar.
          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>
          nnoremap <leader>fh <cmd>Telescope help_tags<cr>
          '';
        plugins = with pkgs.vimPlugins; [
          lazy-nvim
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

              # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter.withAllGrammars
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    # nvim-cmp (autocompletion) and extensions
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    # ^ nvim-cmp extensions
    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    # ^ UI
    # language support
    # ^ language support
    # navigation/editing enhancement plugins
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    # ^ navigation/editing enhancement plugins
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # ^ bleeding-edge plugins from flake inputs
    which-key-nvim

          #pkgs.vimPlugins.LazyVim
          #{
            #plugin = pkgs.vimPlugins.vim-startify;
            #config = "let g:startify_change_to_vcs_root = 0";
          #}
        ];
      };

}
