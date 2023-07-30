-- vim:fdm=marker
-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- It's not worth trying to declaratively manage LSPs within Neovim because NixOS
-- doesn't play well with non-declarative binaries. Just install LSPs separately.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local luasnip = require('luasnip')
local cmp = require('cmp')

-- autocompletion {{{

cmp.setup {
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    window = {completion = cmp.config.window.bordered()},
    mapping = cmp.mapping.preset.insert({
        ['<M-j>'] = {
            i = function()
                if cmp.visible() then
                    cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
                else
                    cmp.complete()
                end
            end
        },
        ['<M-k>'] = {
            i = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Select
            })
        },
        ['<M-l>'] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = {{name = 'nvim_lsp'}, {name = 'luasnip'}}
}
cmp.setup.cmdline({'/', '?'}, {enabled = false})
cmp.setup.cmdline(':', {enabled = false})

-- }}}

-- styling {{{

require('lspconfig.ui.windows').default_options.border = 'single'
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or vim.g.border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false
})

local signs = {Error = "", Warn = "", Hint = "", Info = ""}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- automatically close quickfix list after opening an entry
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        vim.keymap.set('n', '<CR>', '<CR>:lcl<CR>:ccl<CR>', {buffer = true})
    end
})

-- }}}

-- keybinds {{{

vim.keymap.set('n', '<F3>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<F4>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<F5>', vim.diagnostic.setloclist)
vim.keymap.set('n', 'gj',
               function() vim.diagnostic.open_float(nil, {focus = false}) end)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = {buffer = ev.buf, silent = true}
        vim.keymap.set('n', 'gk', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<M-]>', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<M-o>', '<C-o>', opts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    end
})

-- }}}

-- server configurations {{{

local on_attach_ts = function(client)
    local active_clients = vim.lsp.get_active_clients()
    if client.name == 'tsserver' then
        for _, client_ in pairs(active_clients) do
            -- stop denols if tsserver is already active
            if client_.name == 'denols' then client_.stop() end
        end
    elseif client.name == 'denols' then
        for _, client_ in pairs(active_clients) do
            -- prevent denols from starting if tsserver is already active
            if client_.name == 'tsserver' then client.stop() end
        end
    end
end

lspconfig.astro.setup {}
lspconfig.denols.setup {
    on_attach = on_attach_ts,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc')
}
lspconfig.eslint.setup {}
lspconfig.jsonls.setup {}
lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT'},
            diagnostics = {globals = {'vim'}},
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
            telemetry = {enable = false}
        }
    }
}
lspconfig.nixd.setup {}
lspconfig.tsserver.setup {
    on_attach = on_attach_ts,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json',
                                           'jsconfig.json'),
    single_file_support = false
}

-- }}}
