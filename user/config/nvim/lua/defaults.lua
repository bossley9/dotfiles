local set = vim.opt

set.swapfile = false -- disable swapfiles
set.backup = false
set.writebackup = false

-- enabled by default
-- filetype plugin on -- browse filetypes for file syntax

set.updatetime = 300 -- rate at which buffers/gutters refresh
set.signcolumn = 'yes' -- always display gutters

vim.g.netrw_dirhistmax = 0 -- don't save netrw history

set.ignorecase = true -- case-sensitive search only with capitals
set.smartcase = true

set.incsearch = true -- search while typing
set.hlsearch = true -- highlight search

-- enabled by default
-- filetype plugin indent on -- indent tab width

set.expandtab = true -- use spaces instead of tabs
set.shiftround = true -- round indent
set.smartindent = true
set.autoindent = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2

set.shortmess = 'at' -- truncate cmd prompt messages
set.showcmd = false -- hide partial command from cmd prompt
set.showmode = false -- hide mode from cmd prompt

set.number = true -- line numbers
set.showmatch = true -- matching brackets
set.splitright = true -- open vertical windows to the right
set.scrolloff = 0 -- number of lines above and below cursor

-- trailing space characters
set.list = true
set.listchars = 'tab:  ,trail:·'

set.fillchars = set.fillchars + 'eob: ' -- remove end of buffer tildes

set.mouse = 'a' -- mouse input

-- prevent comments from continuing to new lines
-- must be done in autocommand to get set after
-- plugins load
vim.cmd('au FileType * setlocal formatoptions-=cro')

set.encoding = 'utf8' -- set encoding

-- suppress certain number format detection with c-a and c-x
set.nrformats = 'bin,unsigned'
