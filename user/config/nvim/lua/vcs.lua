-- vim:fdm=marker
local utils = require('utils')
local set = vim.opt

local function getSHA()
    local ln = vim.api.nvim_win_get_cursor(0)[1]
    local file = vim.fn.expand('%:p')

    local shaCmd = 'git --no-pager blame ' .. file .. ' -lL' .. ln .. ',' .. ln
    local shaHandle = io.popen(shaCmd)
    if shaHandle == nil then return '' end
    local shaOutput = shaHandle:read '*a'
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
-- prevent signs from covering LSP diagnostics
vim.g.gitgutter_sign_priority = 0
vim.g.gitgutter_sign_allow_clobber = 0

set.signcolumn = 'yes'

-- }}}

-- gitblame {{{

vim.g.gitblame_ignored_filetypes = { 'fern', 'netrw' }
vim.g.gitblame_date_format = '%a %Y-%m-%d %H:%M'

vim.api.nvim_create_user_command('CopySHA', 'GitBlameCopySHA', {})
vim.api.nvim_create_user_command('OpenGitUrl', 'GitBlameOpenCommitURL', {})
vim.api.nvim_create_user_command('Get', function(args)
    vim.cmd(args.line1 .. ',' .. args.line2 .. 'GitBlameCopyFileURL')
end, { range = true })

-- }}}

-- Diff{{{

vim.api.nvim_create_user_command('Diff', function()
    local diffHandle = io.popen('git --no-pager diff HEAD')
    local diff = ''
    if diffHandle ~= nil then
        diff = diffHandle:read('*a')
        diffHandle:close()
    end
    utils.copyToClipboard(diff)
end, {})

-- }}}

-- GoTo...Blame {{{

local function goToBlame()
    os.execute('git reset --hard && git clean -fd')
    os.execute('git -c advice.detachedHead=false checkout ' .. getSHA())
end

vim.api.nvim_create_user_command('GoToBlame', goToBlame, {})

vim.api.nvim_create_user_command('GoToPrevBlame', function()
    goToBlame()
    os.execute('git -c advice.detachedHead=false checkout HEAD~1')
end, {})

-- }}}
