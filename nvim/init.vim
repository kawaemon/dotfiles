set fileencodings=utf-8,cp932,euc-jp,sjis
set nocompatible
set lazyredraw

set tabstop=4
set shiftwidth=4
set expandtab

set autoindent
set autoread
set cursorline
set hidden
set number
set hlsearch
set ruler
set showcmd
set updatetime=300
set signcolumn=yes
set title

" set yanked text to clipboard
set clipboard&
set clipboard^=unnamedplus

set showmatch matchtime=2 " highlight corresponding parenthesis for 0.2 sec
set pumheight=10 " set limit of completion window height

if $NVIM_NO_PLUGIN != '1'
    let s:vimrc_dir = expand('<sfile>:p:h')
    let s:dein_dir = s:vimrc_dir. '/dein'
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

    let s:minimum_plugins = s:vimrc_dir . '/minimum_plugins.toml'
    let s:plugins = s:vimrc_dir . '/plugins.toml'
    let s:lazy_plugins = s:vimrc_dir . '/lazy_plugins.toml'

    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

    let &runtimepath = s:dein_repo_dir . "," . &runtimepath
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir)

        call dein#load_toml(s:minimum_plugins, {'lazy': 0})

        call dein#load_toml(s:plugins, {'lazy': 0})
        call dein#load_toml(s:lazy_plugins, {'lazy': 1})

        call dein#end()
        call dein#save_state()
    endif

    if dein#check_install()
        call dein#install()
    endif
endif

" disable arrow keys.
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

" use Y to yank cursor from end of line
nnoremap Y y$

" use sh and sl to switch between buffers
nnoremap <silent> sh :bp<CR>
nnoremap <silent> sl :bn<CR>

" use w{h,j,k,l} to switch between panels
nnoremap <silent> wh <C-w>w
nnoremap <silent> wj <C-w>j
nnoremap <silent> wk <C-w>k
nnoremap <silent> wl <C-w>l

" use esc-esc for remove search highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

filetype plugin indent on

" https://mickey24.hatenablog.com/entry/20120808/vim_highlight_trailing_spaces
hi link TrailingSpaces Error
match TrailingSpaces /\s\+$/

" coc-tsserver uses "typescript.tsx" filetype insted of "typescriptreact"
au BufNewFile,BufRead *.tsx setf typescript.tsx
au BufNewFile,BufRead *.kt setf kotlin
au BufNewFile,BufRead *.toml setf toml

" if swapfile exists, open file as readonly
augroup swapchoice-readonly
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
augroup END
