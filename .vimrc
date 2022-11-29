" filetype plugin on
if has("autocmd")
  filetype plugin indent on
endif

set title

" visual
set ruler
set showcmd
syntax enable
"set term=xterm-256color
set background=light
"set background=dark

" colorscheme
"set termguicolors
let g:gruvbox_transp_bg = 1
colorscheme gruvbox8
highlight Normal ctermbg=None

" indentation
set ts=4 " tabstop
set sw=4 " shiftwidth
set sts=4 " softtabstop - backspace aligns to indentation
set expandtab
set autoindent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" backup handling
set nobackup
set nowritebackup

" line wrapping
set wrap
set linebreak

" line numbering
set number
set numberwidth=3

" search
set ignorecase
set hlsearch

" mouse control
set mouse=a
set ttymouse=xterm2

" split navitation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" white space chars highlighting
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<
hi SpecialKey guifg=red ctermfg=red

" cursorline in active window only
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END


" PLUGINS

" gruvbox
"autocmd vimenter * ++nested colorscheme gruvbox

" regenerate all tags
helptags ALL

" syntastic
map <F7> <ESC>:call SyntasticToggle()<CR>
function! SyntasticToggle()
  let g:wi = getloclist(2, {'winid' : 1})
  if g:wi != {}
    lclose
  else
    Errors
  endif
endfunction
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" NERDTree
"autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" sunset
let g:loaded_sunset = 1 " disable sunset plugin
let g:sunset_latitude = 49.2
let g:sunset_longitude = 16.6

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
