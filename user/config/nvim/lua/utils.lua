local M = {}

function M.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

function M.getcWORD() return vim.fn.expand('<cWORD>') end

function M.copyToClipboard(content) vim.fn.setreg('+', content) end

-- adapted from https://stackoverflow.com/a/18864453/9714875
-- and https://github.com/f-person/git-blame.nvim/blob/master/lua/gitblame/utils.lua
local open_cmd -- this must stay outside the function to preserve the value
function M.openURL(url)
    if not open_cmd then
        if package.config:sub(1, 1) == '\\' then
            open_cmd = function(_url)
                local handle = io.popen(string.format(
                                            'rundll32 url.dll,FileProtocolHandler "%s"',
                                            _url))
                handle:close()
            end
        elseif (io.popen('uname -s'):read '*a'):match 'Darwin' then
            open_cmd = function(_url)
                local handle = io.popen(string.format('open "%s"', _url))
                handle:close()
            end
        else
            open_cmd = function(_url)
                local handle = io.popen(string.format('xdg-open "%s"', _url))
                handle:close()
            end
        end
    end
    open_cmd(url)
end

return M
