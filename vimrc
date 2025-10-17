" vim: ft=vim
set nocompatible
filetype plugin indent on
syntax on

set fileencodings=utf-8,cp932,sjis

set tabstop=4
set shiftwidth=4
set expandtab

set list
set listchars=tab:>\ ,trail:!
set nowrap
set title
set hidden
set number
set autoread
set laststatus=2
set autoindent
set cursorline
set updatetime=300
set signcolumn=yes
set noshowmode
set termguicolors

if exists("&smoothscroll")
    set smoothscroll
endif

set mouse=a
set clipboard=unnamedplus
set showmatch
set smartcase
set ignorecase
set matchtime=2
set pumheight=20
set diffopt+=algorithm:histogram
set matchpairs+=<:>

colorscheme slate

let g:man_hardwrap = 0

nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <F1> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <F1> <Nop>

nnoremap Y y$

nnoremap sh :bp<CR>
nnoremap sl :bn<CR>
nnoremap sd :b#\|bw#\|bp\|bn<CR>

nnoremap <Esc><Esc> :nohlsearch<CR>

augroup custom_auto
    autocmd!
    autocmd StdinReadPost * set nomodified
    autocmd FocusLost * silent! wa
augroup END

command! W w
command! Wa wa
command! Wq wq
command! Wqa wqa
command! WQ wq
command! Q q
command! Qa qa

