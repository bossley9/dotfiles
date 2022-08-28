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

" interface {{{

" line
hi CursorLine ctermbg=none

" folds
hi Folded cterm=none ctermfg=4 ctermbg=none

" trailing characters
hi NonText ctermfg=0

" fix terminal background
hi Pmenu ctermbg=none

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

hi StatusLineNC ctermbg=none ctermfg=0 cterm=none
hi StatusLine ctermbg=none ctermfg=7 cterm=none
hi StatusLineMode ctermbg=none ctermfg=6 cterm=none
hi StatusLineInactiveMode ctermbg=0 ctermfg=2
hi ErrorMsg ctermbg=none ctermfg=1

" }}}

" syntax {{{

hi Special ctermfg=5
hi Constant ctermfg=5

" }}}

augroup highlights
  au! BufRead,BufNewFile *.{gemini,gmi}  set filetype=gemini textwidth=0 wrap
augroup end
