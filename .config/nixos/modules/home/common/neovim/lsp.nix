{ pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # language parser
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      none-ls-nvim
    ];

    initLua = lib.mkOrder 1600 # lua
      ''
        ----------------------
        -- About treesitter --
        ----------------------
        require('nvim-treesitter').setup()

        -------------------
        -- About none-ls --
        -------------------
        -- format(async)
        local async_formatting = function(bufnr)
          bufnr = bufnr or vim.api.nvim_get_current_buf()

          vim.lsp.buf_request(
            bufnr,
            "textDocument/formatting",
            vim.lsp.util.make_formatting_params({}),
            function(err, res, ctx)
              if err then
                local err_msg = type(err) == "string" and err or err.message
                -- you can modify the log message / level (or ignore it completely)
                vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
                return
              end

              -- don't apply results if buffer is unloaded or has been modified
              if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
                return
              end

              if res then
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
                vim.api.nvim_buf_call(bufnr, function()
                  vim.cmd("silent noautocmd update")
                end)
              end
            end
          )
        end
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        local lsp_formatting = function(bufnr)
          vim.lsp.buf.format({
            filter = function(client)
              -- apply whatever logic you want (in this example, we'll only use null-ls)
              return client.name == "null-ls"
            end,
            bufnr = bufnr,
          })
        end
        require("null-ls").setup({
          sources = {
            -- you must download code formatter by yourself!
            require("null-ls").builtins.formatting.nixfmt,
          },
          debug = false,
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
              vim.api.nvim_create_autocmd("BufWritePost", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  async_formatting(bufnr)
                  lsp_formatting(bufnr)
                end,
              })
            end
          end,
        })
        ---------------------
        -- About LSP         --
        ---------------------
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        vim.diagnostic.config({
          virtual_text = false,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN] = " ",
              [vim.diagnostic.severity.HINT] = " ",
              [vim.diagnostic.severity.INFO] = " ",
            },
          },
          underline = true,
          update_in_insert = true,
          severity_sort = false,
        })

        local lsp_attach = vim.api.nvim_create_augroup("UserLspAttach", {})
        vim.api.nvim_create_autocmd("LspAttach", {
          group = lsp_attach,
          callback = function(ev)
            vim.api.nvim_create_autocmd("CursorHold", {
              buffer = ev.buf,
              callback = function()
                vim.diagnostic.open_float(nil, {
                  focusable = false,
                  close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                  border = "rounded",
                  source = "always",
                  prefix = " ",
                  scope = "line",
                })
              end,
            })
          end,
        })

        vim.lsp.config("nixd", {
          capabilities = capabilities,
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/tmp/NixOS_Home-Manager").nixosConfigurations.hostname.options',
                },
                home_manager = {
                  expr = '(builtins.getFlake "/tmp/NixOS_Home-Manager").homeConfigurations."user@hostname".options',
                },
                flake_parts = {
                  expr = 'let flake = builtins.getFlake ("/tmp/NixOS_Home-Manager"); in flake.debug.options // flake.currentSystem.options',
                },
              },
            },
          },
        })
        vim.lsp.enable("nixd")
      '';
  };
}
