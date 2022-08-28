set noswapfile             " disable swapfiles
filetype plugin on         " browse filetypes for file syntax

let g:netrw_dirhistmax=0   " don't save netrw history

set ignorecase             " case-sensitive search only with capitals
set smartcase

set incsearch              " search while typing
set hlsearch               " highlight search

" indent tab width
filetype plugin indent on
set expandtab              " use spaces instead of tabs
set shiftround             " round indent
set smartindent
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2

set shortmess=at           " truncate cmd prompt messages
set noshowcmd              " hide partial command from cmd prompt
set noshowmode             " hide mode from cmd prompt

set number                 " line numbers
set cursorline             " highlight line number
set showmatch              " matching brackets
set splitright             " open vertical windows to the right
set scrolloff=0            " number of lines above and below cursor

" trailing space characters
set list listchars=tab:\ \ ,trail:·
" effectively remove end of buffer tildes
set fillchars+=eob:\ 

set mouse=a                " mouse input

" prevent comments from continuing to new lines
" must be done in autocommand to get set after
" plugins load
au FileType * setlocal formatoptions-=cro

set encoding=utf8          " set encoding
