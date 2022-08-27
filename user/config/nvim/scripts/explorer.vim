" File explorer setup. Aims to be as close to netrw as possible so I can
" easily switch between non-configured instances.
" vim:fdm=marker

" settings {{{

let g:netrw_banner=0
let g:netrw_liststyle=3

" }}}

" expand and contract {{{

fu! s:expandExplorer()
  exe 'Lex ' . g:projectDir
  nmap <buffer> l <CR>
endfunction

fu! s:contractExplorer()
  Lex
endfunction

" }}}

" toggle {{{

let s:isExpanded = 0

fu! ToggleExplorer()
  if s:isExpanded
    let s:isExpanded = !s:isExpanded
    call s:contractExplorer()
  else
    let s:isExpanded = !s:isExpanded
    call s:expandExplorer()
  endif
endfunction

nnoremap <M-b> :call ToggleExplorer()<CR>

" }}}
