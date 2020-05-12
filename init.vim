lang ja_JP.UTF-8
set encoding=utf-8
if &compatible
  set nocompatible
endif

let s:VimrcDir = expand('<sfile>:p:h')
let s:DeinDir = s:VimrcDir . '/dein'
let s:DeinRepoDir = s:DeinDir . '/repos/github.com/Shougo/dein.vim'
let s:DeinToml = s:VimrcDir . '/plugins.toml'
let s:Lazy_DeinToml = s:VimrcDir . '/lazy_plugins.toml'

if !isdirectory(s:DeinRepoDir) 
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:DeinRepoDir))
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

" disable arrow keys.
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>


" use tab key for completation
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


" coc-tsserver uses "typescript.tsx" filetype insted of "typescriptreact"
au BufNewFile,BufRead *.tsx setf typescript.tsx
au BufNewFile,BufRead *.kt setf kotlin

autocmd CursorHold * silent call CocActionAsync('highlight')
set updatetime=500 " threshold of CursorHold
command! -nargs=0 Format :call CocAction('format') 
command! -nargs=0 Import :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Definition :call CocAction('jumpDefinition')

filetype plugin indent on
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
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
set clipboard=unnamed

hi Constant guifg=#CD9069
hi Comment guifg=#6A9955
hi Ignore guifg=#101010
hi link EndOfBuffer Ignore
hi LineNr guifg=#7F7F7F
hi vimOper guifg=#FFFFFF
hi vimParenSep guifg=#FFFFFF

hi Identifier guifg=#9CDCFE
hi Title guifg=#9CDCFE
hi Statement guifg=#499CD5
hi Type guifg=#4EC9B0
hi Number guifg=#B4CDA8
hi PreProc guifg=#4EC9B0
hi Pmenu guibg=#262626
hi PmenuSel guifg=#262626 guibg=#FFAF5F
hi SignColumn guibg=#101010
hi CursorLine guibg=#262626
hi CursorLineNR guifg=#FFAF5F

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
