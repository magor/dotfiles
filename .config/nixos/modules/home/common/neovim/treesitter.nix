{ pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # language parser — selective grammars (withAllGrammars rebuilds everything)
      (nvim-treesitter.withPlugins (
        p: with p; [
          bash
          c
          cmake
          cpp
          css
          csv
          dart
          diff
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          go
          java
          jq
          json
          lua
          make
          markdown
          markdown_inline
          nix
          python
          query
          regex
          rust
          sql
          toml
          vim
          vimdoc
          xml
          yaml
          zsh
        ]
      ))
    ];

    initLua =
      lib.mkOrder 1600 # lua
        ''
          ----------------------
          -- About treesitter --
          ----------------------
          require('nvim-treesitter').setup()
        '';
  };
}
