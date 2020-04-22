if &compatible
  set nocompatible
endif

let s:VimrcDir = expand('<sfile>:p:h')
let s:DeinDir = s:VimrcDir . '/dein'
let s:DeinRepoDir = s:DeinDir . '/repos/github.com/Shougo/dein.vim'
let s:DeinToml = s:VimrcDir . '/plugins.toml'
let s:Lazy_DeinToml = s:VimrcDir . '/lazy_plugins.toml'

if !isdirectory(s:DeinRepoDir) 
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif

let &runtimepath = s:DeinRepoDir . "," . &runtimepath
if dein#load_state(s:DeinDir)
  call dein#begin(s:DeinDir)
  call dein#load_toml(s:DeinToml, {'lazy': 0})
  call dein#load_toml(s:Lazy_DeinToml, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

if dein#check_install() 
  call dein#install()
endif

nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

filetype plugin indent on
syntax on

set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
set hlsearch
set ruler
set showcmd
set showmatch
set background=dark
set termguicolors
hi Comment guifg=#6A9955
hi Ignore guifg=#101010
hi link EndOfBuffer Ignore
hi LineNr guifg=#7F7F7F

hi Statement guifg=#499CD5
hi Type guifg=#4EC9B0
hi PreProc guifg=#4EC9B0



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
