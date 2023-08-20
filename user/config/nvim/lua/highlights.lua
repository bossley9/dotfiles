-- vim:fdm=marker
local setl = vim.opt_local

-- debug {{{

vim.api.nvim_create_user_command('DebugHighlights', function()
  vim.cmd('so $VIMRUNTIME/syntax/hitest.vim')
end, {})

vim.api.nvim_create_user_command('DebugColor', function()
  vim.cmd('so $VIMRUNTIME/syntax/colortest.vim')
end, {})

vim.api.nvim_create_user_command('DebugColor256', function()
  vim.cmd([[
      new
      let num = 255
      while num >= 0
        exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
        exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
        call append(0, 'ctermbg='.num.':....')
        let num = num - 1
      endwhile
      set ro
      set nomodified
    ]])
end, {})

vim.api.nvim_create_user_command('DebugSynGroup', function()
  vim.cmd([[
      let s = synID(line('.'), col('.'), 1)
      echo synIDattr(s, 'name') . ' -> ' . synIDattr(synIDtrans(s), 'name')
    ]])
end, {})

-- }}}

vim.cmd 'colorscheme nord'

-- floating windows
vim.api.nvim_set_hl(0, "FloatBorder", { fg = 15 })

-- quickfix lists
vim.api.nvim_set_hl(0, "QuickFixLine", { fg = 15, bg = 0 })

vim.cmd([[

" interface {{{

" line
hi CursorLine guibg=0 ctermbg=0

" folds
hi Folded gui=none cterm=none guifg=4 ctermfg=4 guibg=none ctermbg=none

" trailing characters
hi NonText guibg=0 ctermfg=0

" fix terminal background
hi Pmenu guibg=none ctermbg=none

" coc autocompletion menus
hi CocMenuSel guifg=0 ctermfg=0 guibg=6 ctermbg=6
hi FgCocNotificationProgressBgNormal guifg=7 ctermfg=7 guibg=none ctermbg=none

" coc error messages
hi FgCocErrorFloatBgCocFloating guifg=1 ctermfg=1 guibg=none ctermbg=none
hi WarningMsg guifg=3 ctermfg=3 guibg=none ctermbg=none

" }}}

" status line {{{

let g:buffermodes = {
  \'n': 'NORMAL',
  \'v': 'VISUAL',
  \'V': 'V-LINE',
  \"\<C-V>": 'V-BLOCK',
  \'i': 'INSERT',
  \'R': 'REPLACE',
  \'Rv': 'V-REPLACE',
  \'c': 'COMMAND',
  \'t': 'TERMINAL',
\}

fu! g:SetStatusLine(is_focused)
  setlocal statusline=

  " hide statusline for file explorer
  if &ft == 'fern'
    setlocal statusline=\
    return
  en

  if a:is_focused
    setlocal statusline+=%#StatusLineMode#
  en

  setlocal statusline+=%{'\ '}
  setlocal statusline+=%{toupper(g:buffermodes[mode()])}
  setlocal statusline+=%{'\ '}
  setlocal statusline+=%*
  setlocal statusline+=%{'\ '}
  setlocal statusline+=%f\ %r
  setlocal statusline+=%=
  setlocal statusline+=%{'Ln'}\ %l
  setlocal statusline+=%{','}\ %{'Col'}\ %c
  setlocal statusline+=\ %p%%
  setlocal statusline+=\ %y
  setlocal statusline+=%{'\ '}
endfunction

augroup status_line
  au!
  au BufEnter,WinEnter * call SetStatusLine(1)
  au WinLeave * call SetStatusLine(0)
augroup end

hi StatusLineNC guibg=none ctermbg=none guifg=0 ctermfg=0 cterm=none
hi StatusLine guibg=none ctermbg=none guifg=7 ctermfg=7 gui=none cterm=none
hi StatusLineMode guibg=none ctermbg=none guifg=none ctermfg=6 gui=none cterm=none
hi StatusLineInactiveMode guibg=0 ctermbg=0 guifg=2 ctermfg=2
hi ErrorMsg guibg=none ctermbg=none guifg=1 ctermfg=1

" }}}

" syntax {{{

hi Special ctermfg=5
hi Constant ctermfg=5
hi Comment ctermfg=6
hi Italic cterm=italic
hi Visual cterm=reverse

" }}}

" vim-markdown {{{

let g:vim_markdown_folding_disabled = 1 " disable header folding
let g:vim_markdown_no_default_key_mappings = 1 " disable keybinds
let g:vim_markdown_frontmatter = 1 " enable frontmatter highlighting
let g:vim_markdown_strikethrough = 1 " enable strikethrough highlighting

" }}}

" setl iskeyword-=- overrides default behaviour of ignoring dashes as word boundaries
augroup highlights
  au!
  au Filetype css setl iskeyword-=-
  au Filetype fern setl nonumber
  au BufRead,BufNewFile *.json setl ft=json
  au Filetype json5 setl commentstring=//\ %s
  au BufRead,BufNewFile *.m3u setl ft=m3u
  au Filetype nix setl iskeyword-=-
augroup end

]])

-- custom filetype rules {{{

local gid = vim.api.nvim_create_augroup('custom-filetypes', { clear = true })

vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'astro',
  callback = function() setl.commentstring = '// %s' end,
  group = gid,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'deno.lock',
  callback = function() setl.ft = 'json' end,
  group = gid,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.opml',
  callback = function() setl.ft = 'xml' end,
  group = gid,
})

-- }}}
