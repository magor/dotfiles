{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    configure = {
      customRC = ''
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
      #packages.myVimPackage = with pkgs.vimPlugins; {
      #  start = [ vim-airline nvim-tree-lua ];
      #};
    };
  };
}

