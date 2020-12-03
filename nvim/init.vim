lang ja_JP.UTF-8
set encoding=utf-8
if &compatible
  set nocompatible
endif

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set autoread
set cursorline
set number
set nobackup
set nowritebackup
set hlsearch
set ruler
set showcmd
set showmatch
set background=dark
set termguicolors
set updatetime=300
set signcolumn=yes
set clipboard+=unnamed

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

" use sh and sl for switching buffers
nnoremap <silent> sh :bp<CR>
nnoremap <silent> sl :bn<CR>

" use esc-esc for remove search highlight
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

filetype plugin indent on
syntax on

colorscheme xcodedarkhc
hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE

" https://mickey24.hatenablog.com/entry/20120808/vim_highlight_trailing_spaces
hi link TrailingSpaces Error
match TrailingSpaces /\s\+$/

" coc-tsserver uses "typescript.tsx" filetype insted of "typescriptreact"
au BufNewFile,BufRead *.tsx setf typescript.tsx
au BufNewFile,BufRead *.kt setf kotlin
au BufNewFile,BufRead *.toml setf toml

" define SyntaxInfo command for adjusting syntax color.
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
