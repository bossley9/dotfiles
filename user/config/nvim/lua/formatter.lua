local formattingEnabled = true

vim.g.SetFormat = function(value) formattingEnabled = value end

vim.api.nvim_create_user_command('FormatOn',
                                 function() vim.g.SetFormat(true) end,
                                 {nargs = 0})
vim.api.nvim_create_user_command('FormatOff',
                                 function() vim.g.SetFormat(false) end,
                                 {nargs = 0})

vim.g.Format = function()
    local ft = vim.bo.filetype
    local file = vim.fn.expand('%:p')
    -- step 1: silently format the file in place (silent !cmd expand(%:p))
    if ft == 'c' or ft == 'cpp' then
        vim.cmd("exe 'silent !clang-format -i " .. file .. "'")
    elseif ft == 'go' then
        vim.cmd("exe 'silent !gofmt -w " .. file .. "'")
    elseif ft == 'kotlin' then
        vim.cmd("exe 'silent !ktlint -F " .. file .. "'")
    elseif ft == 'lua' then
        vim.cmd("exe 'silent !lua-format -i " .. file .. "'")
    elseif ft == 'nix' then
        vim.cmd("exe 'silent !nixpkgs-fmt " .. file .. "'")
    elseif ft == 'rust' then
        vim.cmd("exe 'silent !rustfmt " .. file .. "'")
    end
    -- step 2: reload formatting changes
    vim.cmd 'e'
    -- step 3: reload syntax highlighting
    vim.cmd 'redraw'
    -- step 4: reopen the currently closed fold
    vim.cmd 'norm! zv'
end

vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*',
    callback = function() if formattingEnabled then vim.g.Format() end end
})
