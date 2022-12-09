local utils = require('utils')
local map = utils.map

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

-- brace completion
map('i', '[', '[]<Esc>i')
map('i', '{', '{}<Esc>i')
map('i', '(', '()<Esc>i')

-- code commenting
-- must not be recursive
vim.cmd([[
  imap <M-/> <Esc>gc<Right><Right>i
  nmap <M-/> <Esc>gc<Right>
  vmap <M-/> gcgv
]])

-- clipboard
map('v', '<C-c>', '"+ygv')
map('n', '<C-c>', '"+ygv')
vim.api.nvim_create_user_command(
  'File',
  function() utils.copyToClipboard(utils.expand('%')) end,
  {}
)

-- gx browser
vim.api.nvim_create_user_command(
  'GXBrowse',
  function()
    local url = utils.getcWORD()
    utils.openURL(url)
  end,
  {}
)
map('n', 'gx', ":GXBrowse<CR>")

-- Nixpkgs browser
vim.api.nvim_create_user_command(
  'Nix',
  function()
    local baseURL = 'https://github.com/NixOS/nixpkgs/blob/master/'
    local path = utils.getcWORD():gsub('^<nixpkgs/', ''):gsub('>$', '')
    utils.openURL(baseURL .. path)
  end,
  {}
)
