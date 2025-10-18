{ pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # nvim-tree file browser
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup()
          vim.keymap.set('n', '<C-n>', ':NvimTreeFindFileToggle<CR>')
        '';
      }

      # show available keybinds
      which-key-nvim

      # outline window (including markdown)
      outline-nvim

      # UI
      lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
      nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
      statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
      nvim-treesitter-context # nvim-treesitter-context
      bufferline-nvim # show open buffers at top
      noice-nvim # Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    ];

    extraConfig = # vim
      ''
        " FIXME doesn't work
        " workaround? (hint: order of import vs default.nix)
        let mapleader=" "
        nnoremap <leader>o <cmd>Outline<cr>
      '';

    extraLuaConfig = # lua
      ''
        require("lualine").setup({
          options = {
            theme = "auto",
            globalstatus = true,
          },
        })
        require("outline").setup({})
        require("bufferline").setup({})

        -----------------
        -- About noice --
        -----------------
        require("noice").setup({
          routes = {
            {
              filter = {
                event = "msg_show",
                any = {
                  { find = "%d+L, %d+B" },
                  { find = "; after #%d+" },
                  { find = "; before #%d+" },
                  { find = "%d fewer lines" },
                  { find = "%d more lines" },
                },
              },
              opts = { skip = true },
            },
          },
        })
      '';
  };
}
