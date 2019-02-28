execute pathogen#infect()

"filetype plugin on
if has("autocmd")
  filetype plugin indent on
endif

" visual
set ruler
set showcmd
syntax enable
"set term=xterm-256color
set background=dark

" solarized
"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
colorscheme solarized

" indentation
set ts=4 " tabstop
set sw=4 " shiftwidth
set sts=4 " softtabstop - backspace aligns to indentation
set expandtab
set autoindent

" backup handling
set nobackup
set nowritebackup

" line wrapping
set nowrap

" line numbering
set number
set numberwidth=3

" search
set ignorecase
set hlsearch

" mouse control
"set mouse=a
"set ttymouse=xterm2

" white space chars highlighting
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

" NERDTree
"autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
