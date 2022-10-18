local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- nohl
map('n', '<Space>', ':noh<CR>')

-- <Esc>, <CR>, <BS>
map('n', '<M-;>', '<Esc>')
map('v', '<M-;>', '<Esc>')
map('c', '<M-;>', '<Esc>')

map('i', '<M-h>', '<BS>')

-- normal mode space
map('n', '<M-Space>', 'i<Space><Esc>')

-- normal mode CR
map('n', 'K', 'i<CR><Esc>')

local navJump = 5
local navJumpLarge = 25

-- vertical navigation
map('n', '<M-j>', navJump .. 'j')
map('v', '<M-j>', navJump .. 'j')

map('n', '<M-k>', navJump .. 'k')
map('v', '<M-k>', navJump .. 'k')

map('n', '<M-d>', navJumpLarge .. 'j')
map('v', '<M-d>', navJumpLarge .. 'j')

map('n', '<M-u>', navJumpLarge .. 'k')
map('v', '<M-u>', navJumpLarge .. 'k')

-- buffer navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map('n', '<M-h>', '<C-w>h')
map('n', '<M-l>', '<C-w>l')

map('n', '=', '<C-w>=')

-- close and save
map('n', 'ZZ', ':up<CR>:qa!<CR>')
map('n', 'ZQ', ':qa!<CR>')

-- indentation
map('n', '<Tab>', '>>')
map('v', '<Tab>', '>gv')

map('i', '<S-Tab>', '<C-d>')
map('n', '<S-Tab>', '<<')
map('v', '<S-Tab>', '<gv')

-- code commenting
vim.cmd([[
  imap <M-/> <Esc>gc<Right><Right>i
  nmap <M-/> <Esc>gc<Right>
  vmap <M-/> gcgv
]])

-- clipboard
map('v', '<C-c>', '"+ygv')
map('n', '<C-c>', '"+ygv')
vim.cmd("com! File exe 'silent !echo '.expand('%').' | wl-copy'")

-- replace window preview (fzf.vim)
vim.cmd('com! W w')

-- gx browser
map('n', 'gx', ":silent! exe '!$BROWSER '.fnameescape(expand('<cWORD>'))<CR>")

-- Nixpkgs browser
vim.cmd("com! Nix silent exe '!$BROWSER https://github.com/NixOS/nixpkgs/blob/master/'.substitute(substitute(expand('<cWORD>'), '<nixpkgs/', '', ''), '>', '', '')")
