-- Automatic session management. No configuration needed!
-- vim:fdm=marker
-- directory setup {{{
local sessionDir = vim.fn.stdpath('data') .. '/sessions' .. vim.g.projectDir
local sessionFile = sessionDir .. '/se'

os.execute('mkdir -p ' .. sessionDir)

-- }}}

-- deleteHiddenBuffers {{{

local manPrefix = "man://"
local fernPrefix = "fern://"

local function deleteHiddenBuffers()
    for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
        local btype = vim.fn.getbufvar(bufnr, "&buftype")
        local bname = vim.fn.bufname(bufnr)

        if (btype ~= 'terminal') -- if buffer is NOT a terminal (terminals break indices)
        and ( -- and
        (not (vim.api.nvim_buf_is_valid(bufnr) and
            vim.fn.getbufvar(bufnr, '&buflisted') == 1)) -- if buffer is inactive
        or -- or
            (btype == 'help' or btype == 'quickfix' or bname:sub(1, #manPrefix) ==
                manPrefix) -- if buffer is informational
        or -- or
        (btype == 'directory' or bname == 'NetrwTreeListing' or
            bname:sub(1, #fernPrefix) == fernPrefix)) -- if buffer is a file explorer
        then vim.api.nvim_buf_delete(bufnr, {force = true}) end
    end
end

-- }}}

-- session listeners {{{

local function saveSession()
    deleteHiddenBuffers()
    vim.cmd('mksession! ' .. sessionFile)
end

local function restoreSession()
    local f = io.open(sessionFile, 'r')
    if f ~= nil then
        io.close(f)
        vim.cmd('so ' .. sessionFile)
    else
        -- Folder is opened for the first time.
        -- Delete the netrw buffer!
        vim.api.nvim_buf_delete(0, {})
    end
end

vim.api.nvim_create_autocmd({'VimEnter'}, {
    pattern = {'*'},
    nested = true,
    callback = function()
        if vim.g.openedWithDir == 1 then restoreSession() end
    end
})

vim.api.nvim_create_autocmd({'VimLeave'}, {
    pattern = {'*'},
    callback = function() if vim.g.openedWithDir == 1 then saveSession() end end
})

-- }}}

-- ResetSession {{{

vim.api.nvim_create_user_command('ResetSession', function()
    deleteHiddenBuffers()
    os.execute('rm -f ' .. sessionFile)
    print("session was reset.")
end, {})

-- }}}
