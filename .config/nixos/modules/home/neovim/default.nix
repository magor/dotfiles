{
  config,
  lib,
  pkgs,
  ...
}:

{
  # TODO
  # - fix bradcrumbs (lspsaga) https://nvimdev.github.io/lspsaga/breadcrumbs/
  # - fix deprecation warning (use vim.diagnostic.config instead of sign_define) https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.status()
  # - use italics (comments etc)

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nil # nix LSP
    nixd
    nixfmt-rfc-style # needed by configuration, look for nixfmt
  ];

  imports = [
    ./cmp.nix
    ./lsp.nix
    ./ui.nix
    #./toclean.nix
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      pkgs.gcc # needed for lsp/treesitter?
    ];

    extraLuaConfig = # lua
      ''
        local options = {
          updatetime = 50, -- faster completion (4000ms default)
          scrolloff = 5,
        }

        for k, v in pairs(options) do
          vim.opt[k] = v
        end

        -------------------
        -- About lspsaga --
        -------------------
        local colors, kind
        colors = { normal_bg = "#3b4252" }
        require("lspsaga").setup({
            ui = {
                colors = colors,
                kind = kind,
                border = "single",
            },
            outline = {
                win_width = 25,
            },
        })
        -- FIXME vim.cmd([[ colorscheme nord ]])

        local keymap = vim.keymap.set

        -- Lsp finder
        -- Find the symbol definition, implementation, reference.
        -- If there is no implementation, it will hide.
        -- When you use action in finder like open, vsplit, then you can use <C-t> to jump back.
        keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true, desc = "Lsp finder" })

        -- Code action
        keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true, desc = "Code action" })
        keymap("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true, desc = "Code action" })

        -- Rename
        keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true, desc = "Rename" })
        -- Rename word in whole project
        keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>", { silent = true, desc = "Rename in project" })

        -- Peek definition
        keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { silent = true, desc = "Peek definition" })

        -- Go to definition
        keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { silent = true, desc = "Go to definition" })

        -- Show line diagnostics
        keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, desc = "Show line diagnostics" })

        -- Show cursor diagnostics
        keymap(
            "n",
            "<leader>sc",
            "<cmd>Lspsaga show_cursor_diagnostics<CR>",
            { silent = true, desc = "Show cursor diagnostic" }
        )

        -- Show buffer diagnostics
        keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", { silent = true, desc = "Show buffer diagnostic" })

        -- Diagnostic jump prev
        keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, desc = "Diagnostic jump prev" })

        -- Diagnostic jump next
        keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, desc = "Diagnostic jump next" })

        -- Goto prev error
        keymap("n", "[E", function()
            require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, { silent = true, desc = "Goto prev error" })

        -- Goto next error
        keymap("n", "]E", function()
            require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, { silent = true, desc = "Goto next error" })

        -- Toggle outline
        keymap("n", "ss", "<cmd>Lspsaga outline<CR>", { silent = true, desc = "Toggle outline" })

        -- Hover doc
        keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>", { silent = true, desc = "Hover doc" })

        -- Incoming calls
        keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { silent = true, desc = "Incoming calls" })

        -- Outgoing calls
        keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { silent = true, desc = "Outgoing calls" })

        -- Float terminal
        keymap("n", "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { silent = true, desc = "Float terminal" })
        keymap("t", "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { silent = true, desc = "Float terminal" })
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

      luasnip # snippets | https://github.com/l3mon4d3/luasnip/

      # fuzzy finder
      telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
      telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim

      # Useful utilities
      #nvim-unception # Prevent nested neovim sessions | nvim-unception
      lspsaga-nvim

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
