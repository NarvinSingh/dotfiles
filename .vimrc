"
" Visual Elements
"

" Colors
syntax on

" Line numbers
set number relativenumber

"
" Mappings
"

" Leader
let mapleader = ' '

" Insert Mode -> Normal Mode
inoremap jk <Esc>

" Navigate splits
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" Edit .vimrc
nnoremap <silent> <Leader>ev :vsplit $MYVIMRC<CR>

" Save and source current file
nnoremap <silent> <Leader>ss :w<CR>
  \ :source %<CR>
  \ :echo 'Sourced ' . bufname('%')<CR>

