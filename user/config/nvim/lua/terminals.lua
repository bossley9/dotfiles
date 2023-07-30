-- Easier terminal buffers, similar to VSCode's terminal popup window.
-- vim:fdm=marker
local map = require('utils').map

-- setup and variables {{{

local numTerminals = 5

local shellName = vim.fn.expand('$SHELL')
if #shellName == 0 then shellName = 'sh' end

local termList = {}
for i = 0, numTerminals - 1 do termList[i] = -1 end

local window = {isOpen = false, win = -1, index = 0}

-- }}}

-- create and exit terminal buffers {{{

local function createTerminal()
    vim.fn.termopen(shellName, {
        on_exit = function()
            vim.api.nvim_buf_delete(0, {force = true}) -- kill terminal window
            termList[window.index] = -1
            window.isOpen = false
            window.win = -1
            window.index = 0
        end,
        cwd = vim.g.projectDir
    })
end

-- }}}

-- open window {{{

local function openWindow()
    local opts = {x = 0, y = 0, w = 1, h = 1}
    local _columns = vim.go.columns
    local _lines = vim.go.lines

    local col = math.floor(_columns * opts.x)
    local row = math.floor(_lines * opts.y)
    local width = math.floor(_columns * opts.w)
    local height = math.floor(_lines * opts.h)

    local fgOpts = {
        relative = 'editor',
        style = 'minimal',
        col = col + 2,
        row = row + 1,
        width = width - 3,
        height = height - 3,
        border = vim.g.border
    }

    -- open with current buffer for now - we'll replace it with a terminal later
    local win = vim.api.nvim_open_win(0, true, fgOpts)

    window.win = win
    window.isOpen = true
end

-- }}}

-- toggle terminal window {{{

vim.g.ToggleTermWindow = function()
    if window.isOpen then -- if terminal window exists and is open
        window.isOpen = false
        vim.api.nvim_set_current_win(window.win)
        vim.cmd('hide')

    else -- if terminal window is closed or does not exist yet
        window.isOpen = true
        openWindow()
        vim.g.FocusTerminal(window.index)
    end
end

-- }}}

-- focus terminal {{{

vim.g.FocusTerminal = function(i)
    window.index = i
    local hasNoTermBuf = termList[window.index] < 0

    if hasNoTermBuf then
        termList[window.index] = vim.api.nvim_create_buf(false, true)
    end

    vim.api.nvim_set_current_buf(termList[window.index])

    if hasNoTermBuf then createTerminal() end

    vim.cmd('startinsert')
end

-- }}}

-- keymaps {{{

for i = 0, numTerminals - 1 do
    map('t', '<M-' .. (i + 1) .. '>', function() vim.g.FocusTerminal(i) end,
        {silent = true})
end

map('n', '<M-`>', ':call g:ToggleTermWindow()<CR>', {silent = true})
map('t', '<M-`>', '<C-\\><C-n>:call g:ToggleTermWindow()<CR>', {silent = true})

-- }}}
