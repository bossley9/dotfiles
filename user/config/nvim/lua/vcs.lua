-- vim:fdm=marker

local utils = require('utils')
local set = vim.opt

local function getSHA()
  local ln = vim.api.nvim_win_get_cursor(0)[1]
  local file = utils.expand('%:p')

  local shaCmd = 'git --no-pager blame ' .. file .. ' -lL' .. ln .. ',' .. ln
  local shaHandle = io.popen(shaCmd)
  local shaOutput = shaHandle:read'*a'
  local sha = shaOutput:sub(1, shaOutput:find(' '))
  shaHandle:close()
  return sha
end

-- gitgutter {{{

local vcs = '│'

-- disable gutter mappings
vim.g.gitgutter_map_keys = 0
-- gutter refresh rate
set.updatetime = 300
-- gutter symbols
vim.g.gitgutter_sign_added = vcs
vim.g.gitgutter_sign_modified = vcs
vim.g.gitgutter_sign_removed = vcs
vim.g.gitgutter_sign_removed_first_line = vcs
vim.g.gitgutter_sign_modified_removed = vcs

set.signcolumn = 'yes'

-- }}}

-- gitblame {{{

vim.g.gitblame_ignored_filetypes = { 'fern', 'netrw' }
vim.g.gitblame_date_format = '%a %d %b %Y %H:%M'

vim.api.nvim_create_user_command('CopySHA', 'GitBlameCopySHA', {})

-- }}}

-- OpenGitUrl {{{

local remoteHandle = io.popen('git config --get remote.origin.url')
local remote = remoteHandle:read'*a':gsub('\r?\n', ''):gsub('.git$', '')
remoteHandle:close()

vim.api.nvim_create_user_command(
  'OpenGitUrl',
  function()
    local sha = getSHA()

    local baseURL = remote
    local domain, path = string.match(remote, "git%@(.*)%:(.*)")
    if domain and path then
      baseURL = 'https://' .. domain .. '/' .. path
    end

    local url = baseURL .. '/commit/' .. sha
    utils.openURL(url:gsub(' ', ''))
  end,
  {}
)

-- }}}

-- DiffFile {{{

vim.api.nvim_create_user_command(
  'DiffFile',
  function()
    local file = utils.expand('%:p')

    local diffCmd = 'git --no-pager diff ' .. file
    local diffHandle = io.popen(diffCmd)
    local diff = diffHandle:read'*a'
    diffHandle:close()

    utils.copyToClipboard(diff)
  end,
  {}
)

-- }}}

-- GoTo...Blame {{{

local function goToBlame()
    local sha = getSHA()
    os.execute('git reset --hard && git clean -fd')
    os.execute('git -c advice.detachedHead=false checkout ' .. sha)
end

vim.api.nvim_create_user_command('GoToBlame', goToBlame, {})

vim.api.nvim_create_user_command(
  'GoToPrevBlame',
  function()
    goToBlame()
    os.execute('git -c advice.detachedHead=false checkout HEAD~1')
  end,
  {}
)

-- }}}
