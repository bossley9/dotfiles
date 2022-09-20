" vim:fdm=marker

" debug {{{

fu! g:DebugHighlights()
  so $VIMRUNTIME/syntax/hitest.vim
endfunction
com! DebugHighlights call DebugHighlights()

fu! g:DebugColor()
  so $VIMRUNTIME/syntax/colortest.vim
endfunction
com! DebugColor call DebugColor()

fu! g:DebugColor256()
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
endfunction
com! DebugColor256 call DebugColor256()

fu! g:DebugSynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction
com! DebugSynGroup call DebugSynGroup()

" }}}

colorscheme nord
" set termguicolors

" interface {{{

" line
hi CursorLine guibg=0 ctermbg=0

" folds
hi Folded gui=none cterm=none guifg=4 ctermfg=4 guibg=none ctermbg=none

" trailing characters
hi NonText guibg=0 ctermfg=0

" fix terminal background
hi Pmenu guibg=none ctermbg=none

" coc autocompletion menu
hi CocMenuSel guifg=0 ctermfg=0 guifg=6 ctermbg=6
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

" }}}

augroup highlights
  au!
  " setl iskeyword-=- overrides default behaviour of ignoring dashes as word boundaries
  au BufRead,BufNewFile *.babel setl ft=javascript
  au Filetype css setl iskeyword-=-
  au Filetype fern setl nonumber
  au BufRead,BufNewFile *.{gemini,gmi} set ft=gemini commentstring=-\ [\ ]\ %s
  au Filetype json5 setl commentstring=//\ %s
  au BufRead,BufNewFile *.m3u setl ft=m3u
  au Filetype nix setl iskeyword-=-
augroup end
