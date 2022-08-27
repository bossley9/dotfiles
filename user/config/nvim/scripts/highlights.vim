" vim:fdm=marker

" debug {{{

fu! g:DebugHighlights()
  so $VIMRUNTIME/syntax/hitest.vim
endfunction

fu! g:DebugColor()
  so $VIMRUNTIME/syntax/colortest.vim
endfunction

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

fu! g:DebugSynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction

" }}}

hi Pmenu ctermbg=none ctermfg=7
