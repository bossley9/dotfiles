-- Automatic session management. No configuration needed!
-- vim:fdm=marker
-- directory setup {{{
local sessionDir = vim.fn.stdpath('data') .. '/sessions' .. vim.g.projectDir
local sessionFile = sessionDir .. '/se'

os.execute('mkdir -p ' .. sessionDir)

-- }}}

-- deleteHiddenBuffers {{{

local manPrefix = 'man://'
local fernPrefix = 'fern://'

local function deleteHiddenBuffers()
    for _, binfo in pairs(vim.fn.getbufinfo()) do
        local bname = binfo.name
        local btype = vim.fn.getbufvar(binfo.bufnr, '&buftype')

        local isHiddenBuffer = binfo.hidden == 1
        -- terminal buffers break indices if closed automatically
        -- they will be closed anyways when parent process (nvim) closes
        local isNotTerminalBuffer = btype ~= 'terminal'
        local isScratchBuffer = bname == '' or btype == 'nofile'
        local isInformationalBuffer = btype == 'help' or btype == 'quickfix' or
                                          bname:sub(1, #manPrefix) == manPrefix
        local isFileExplorerBuffer = btype == 'directory' or bname ==
                                         'NetrwTreeListing' or
                                         bname:sub(1, #fernPrefix) == fernPrefix

        if (isNotTerminalBuffer and
            (isHiddenBuffer or isScratchBuffer or isInformationalBuffer or
                isFileExplorerBuffer)) then
            -- delete the buffer
            vim.api.nvim_buf_delete(binfo.bufnr, {force = true})
        end
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
