" ================================================
" globals
" ================================================

" note: expand() adds forward slash to end of path

" cache data directory
let g:data_dir = expand('$XDG_DATA_HOME/nvim')

" configuration directory
let g:config_dir = expand('$XDG_CONFIG_HOME/nvim')

" current working directory and if opened with directory
" fixes bug where dir returned from pwd is inconsistent
let g:opened_with_dir = 0
let s:args = argv()
if len(s:args) > 0 && isdirectory(s:args[0])
  exe 'cd '.s:args[0]
  let g:opened_with_dir = 1
endif
if len(s:args) == 0 | let g:opened_with_dir = 1 | endif
" resolve resolves symbolic links
" fnameescape escapes paths with spaces, e.g. My\ Docs/
let g:cwd = fnameescape(resolve(trim(execute('pwd'))))

" fix runtime path on NixOS
exe 'set rtp^=' . g:data_dir
exe 'set rtp+=' . g:data_dir . '/site'
exe 'set rtp+=' . g:config_dir

" ================================================
" plugins
" ================================================

let s:vim_plug = g:data_dir . '/site/autoload/plug.vim'
let s:plugin_dir = g:data_dir . '/plugins'

" automated plugin installation
" if vim-plug does not exist
if ! filereadable(s:vim_plug)
  " install vim-plug
  exe '!curl -fLo ' . s:vim_plug . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  " install plugins, source vimrc, then quit
  au VimEnter * PlugInstall --sync | so $MYVIMRC | qa
endif

call plug#begin(s:plugin_dir)
call plug#end()

" plugin compatibility and stop using vi utilities
set nocompatible
" enable plugins
filetype plugin on

" ================================================
" defaults
" ================================================ 

" disable swap files
set noswapfile

" disable viminfo
if has('nvim')
  let &viminfo=""
else
  set viminfo=""
en

" case sensitive only with captials
set ignorecase
set smartcase

" search while typing
set incsearch
" display highlight
set hlsearch

" indent tab width
filetype plugin indent on
let s:indent = 2
let &tabstop=s:indent
let &softtabstop=s:indent
let &shiftwidth=s:indent
" use spaces instead of tabs
set expandtab

" prevent comments from continuing to new lines
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" remove file name from command bar
set shortmess+=F

" hide mode from command bar
set noshowmode

" enable mouse input
set mouse=a

" line numbers
set number

" show matching brackets
set showmatch

" open vertical windows to the right
set splitright

" lines above and below cursor at all times
set scrolloff=5

" trailing space characters
set list listchars=tab:\ \ ,trail:·

" ================================================
" clear inactive buffers
" ================================================

fu! s:clear_inactive_buffers()
  let l:all_bufs = split(execute('ls!'), '\n')

  " According to the help docs, removal of the current
  " element from a list does not negatively affect list
  " iteration. See ':h for' for more details.
  for l:buf in l:all_bufs
    let l:tokens = split(l:buf)
    if len(l:tokens) > 1
      " if buffers do not have flags, this will output
      " the buffer name - but this does not affect the
      " output (see below)
      let l:flags = l:tokens[1]

      let l:bufnr = l:tokens[0]
      " remove the 'u' from 'unlisted' buffer indices
      if l:bufnr =~ 'u'
        let l:bufnr = substitute(l:bufnr, 'u', '', '')
      en

      " if no flags are present, or flags are not
      " active/active current
      if len(l:tokens) < 5 ||
        \ (l:flags != 'a' &&
        \ l:flags != '#a' &&
        \ l:flags != '%a')

        " down with the guillotine!
        exe 'bw!'.l:bufnr
      en
    en
  endfor
endfunction

" ================================================
" session management
" ================================================

let s:sess_dir = g:data_dir . '/sessions' . g:cwd
let s:sess_file = s:sess_dir . '/se'

" make session directory
call mkdir(s:sess_dir, 'p')

fu! s:session_save()
  " close side file explorer
  if exists("*NERDTreeClose")
    NERDTreeClose
  endif


  " keep only active (non-terminal) buffers
  call s:clear_inactive_buffers()

  " save session
  exe 'mksession! '.s:sess_file
endfunction

fu! s:session_restore()
  " if session exists, restore
  if filereadable(s:sess_file)
    exe 'so '.s:sess_file
  en
endfunction

augroup session_management
  au!
  au VimEnter * nested if g:opened_with_dir | call s:session_restore() | en
  au VimLeave * if g:opened_with_dir | call s:session_save() | en
augroup end

" ================================================
" basic bindings
" ================================================

" closing and saving
nnoremap ZZ :xa<CR>
nnoremap ZQ :qa!<CR>

" to prevent annoying modals and errors
" from mistyping and clumsiness
com! W norm <Esc>:w<CR>

nnoremap <Space> <Esc>:noh<CR>

" no help docs
nnoremap K k

" M-Space to insert a space in normal mode
nnoremap <M-Space> i<Space><Esc>

" <CR>, <Esc>, <BS> basics
inoremap <M-h> <BS>
inoremap <M-j> <CR>

inoremap <M-;> <Esc>
vnoremap <M-;> <Esc>
cnoremap <M-;> <Esc>

let s:nav_jump = 5
let s:nav_jump_large = 25

" vertical navigation
exe 'nnoremap <M-j> ' . s:nav_jump . 'j'
exe 'nnoremap <M-k> ' . s:nav_jump . 'k'
exe 'vnoremap <M-j> ' . s:nav_jump . 'j'
exe 'vnoremap <M-k> ' . s:nav_jump . 'k'

exe 'nnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'nnoremap <M-u> ' . s:nav_jump_large . 'k'
exe 'vnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'vnoremap <M-u> ' . s:nav_jump_large . 'k'
exe 'nnoremap <C-d> ' . s:nav_jump_large . 'j'
exe 'nnoremap <C-u> ' . s:nav_jump_large . 'k'
exe 'vnoremap <C-d> ' . s:nav_jump_large . 'j'
exe 'vnoremap <C-u> ' . s:nav_jump_large . 'k'

" buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <M-h> <C-w>h
nnoremap <M-l> <C-w>l

nnoremap = <C-w>=
