-- vim:fdm=marker
local utils = require('utils')
local set = vim.opt

local function getSHA()
    local ln = vim.api.nvim_win_get_cursor(0)[1]
    local file = vim.fn.expand('%:p')

    local shaCmd = 'git --no-pager blame ' .. file .. ' -lL' .. ln .. ',' .. ln
    local shaHandle = io.popen(shaCmd)
    local shaOutput = shaHandle:read '*a'
    local sha = shaOutput:sub(1, shaOutput:find(' '))
    shaHandle:close()
    return sha
end

local remoteHandle = io.popen('git config --get remote.origin.url')
local remote = remoteHandle:read '*a':gsub('\r?\n', ''):gsub('.git$', '')
remoteHandle:close()

local domain, path = string.match(remote, "git%@(.*)%:(.*)")
local remoteURL = remote
if domain and path then remoteURL = 'https://' .. domain .. '/' .. path end
local remoteURL = remoteURL:gsub(' ', '')

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

vim.g.gitblame_ignored_filetypes = {'fern', 'netrw'}
vim.g.gitblame_date_format = '%a %d %b %Y %H:%M'

vim.api.nvim_create_user_command('CopySHA', 'GitBlameCopySHA', {})

-- }}}

-- OpenGitUrl {{{

vim.api.nvim_create_user_command('OpenGitUrl', function()
    local url = remoteURL .. '/commit/' .. getSHA()
    utils.openURL(url:gsub(' ', ''))
end, {})

-- }}}

-- GitSelection {{{

vim.api.nvim_create_user_command('GitSelection', function(args)
    local latestSHACmd = 'git rev-parse HEAD'
    local latestSHAHandle = io.popen(latestSHACmd)
    local latestSHA = latestSHAHandle:read('*a'):gsub('\n', '')
    latestSHAHandle:close()

    local url = remoteURL .. '/tree/' .. latestSHA .. '/' .. vim.fn.expand('%')

    if (args.range == 2) then
        local startLn = vim.fn.getpos("'<")[2]
        local endLn = vim.fn.getpos("'>")[2]

        if (remoteURL:find('git.sr.ht')) then
            url = url .. '?view-source#L' .. startLn .. '-' .. endLn
        elseif (remoteURL:find('github.com')) then
            url = url .. '?plain=1#L' .. startLn .. '-L' .. endLn
        end
    end

    utils.copyToClipboard(url)
end, {range = '%'})

-- }}}

-- Diff{{{

vim.api.nvim_create_user_command('Diff', function()
    local diffHandle = io.popen('git --no-pager diff HEAD')
    local diff = diffHandle:read('*a')
    diffHandle:close()
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
