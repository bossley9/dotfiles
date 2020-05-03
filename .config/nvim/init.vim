" neovim configuration
"
" install plugins with vim-plug first:
" :PlugInstall

" ------------------------------------------------------------------------------
" plugins
" ------------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot' " improved syntax highlighting
Plug 'sainnhe/edge' " color scheme
" Plug 'pangloss/vim-javascript' " js syntax highlighting

call plug#end()

" ------------------------------------------------------------------------------
" plugin settings
" ------------------------------------------------------------------------------

let g:hardtime_default_on = 1 " hardtime on by default

" ------------------------------------------------------------------------------
"  general configuration
" ------------------------------------------------------------------------------

" disable swap files
set noswapfile

" recursive path searching
set path+=**
set wildignore+=**/node_modules/**,**/.git/**

" look for tags in .git
set tags+=./.git/tags;

" netrw file browser
" hide banner
let g:netrw_banner=0
" open split to the right
let g:netrw_altv=1
" tree view
let g:netrw_liststyle=3

" line numbers
set number

" only search by case when using capital letters
set ignorecase
set smartcase

" turn magic on for regex
set magic

" show matching brackets
set showmatch

" use spaces instead of tabs
set expandtab
" one tab is x many spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2

" enable for various plugin compatibility
" and stop using vi stuff
set nocompatible

" enable incremental search (search highlights while typing)
set incsearch
set hlsearch
" pressing Esc will not remove search position
" set cpoptions+=x
" turn off highlighting
nnoremap <esc><esc> :silent! noh<cr>

" basic syntax highlighting
filetype plugin on
syntax on
filetype indent on

" disable arrow key bindings
" no pain, no gain
for i in ['Left', 'Down', 'Up', 'Right']
  execute 'nnoremap <' . i . '> :echo "' . i . ' has been disabled by the user."<CR>'
  execute 'vnoremap <' . i . '> <C-u>:echo "' . i . ' has been disabled by the user."<CR>'
  execute 'inoremap <' . i . '> <C-o>:echo "' . i . ' has been disabled by the user."<CR>'
endfor

" color scheme
" important!!
set termguicolors
" for dark version
set background=dark
" the configuration options should be placed before `colorscheme edge`
let g:edge_disable_italic_comment = 1
colorscheme edge
hi Normal       ctermbg=None guibg=None
hi NonText      ctermbg=None guibg=None
hi EndOfBuffer  ctermbg=None guibg=None

" automatically install plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" make visual highlight more visible
hi Visual cterm=reverse gui=reverse
