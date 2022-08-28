" Simple file explorer using netrw. Made to be vifm-like.
" vim:fdm=marker

" file explorer {{{

" settings {{{

let g:netrw_banner=0 " hide banner
let g:netrw_liststyle=3 " display tree
let g:netrw_use_errorwindow = 0 " hide error window
let g:netrw_browse_split = 0
let g:netrw_list_hide = netrw_gitignore#Hide() . ',.git'

" do not modify
let s:explorerName = "NetrwTreeListing"
let s:prevWin = -1

hi! link netrwMarkFile Search

" }}}

" expand and contract {{{

fu! s:expandExplorer()
  let l:buf = bufnr(s:explorerName)
  let s:prevWin = nvim_get_current_win()

  40Vex

  if l:buf >= 0
    call nvim_set_current_buf(l:buf)
  endif

  let b:isExplorer = 1
  nmap <buffer> l <CR>
  nmap <buffer> h -
endfunction

fu! s:contractExplorer()
  let l:buf = bufnr(s:explorerName)
  if l:buf >= 0
    call nvim_buf_delete(l:buf, { 'force': 1 })
    call nvim_set_current_win(s:prevWin)
  endif
endfunction

" }}}

" netrw buffer listeners {{{

fu! g:OnLeaveExplorer()
  let s:isExpanded = 0
  call s:contractExplorer()
endfunction

augroup explorer
  au!
  exe 'au BufLeave '.s:explorerName.' if exists("b:isExplorer") | call OnLeaveExplorer() | en'
augroup end

" }}}

" toggle {{{

let s:isExpanded = 0

fu! ToggleExplorer()
  if s:isExpanded
    let s:isExpanded = 0
    call s:contractExplorer()
  else
    let s:isExpanded = 1
    call s:expandExplorer()
  endif
endfunction

nnoremap <silent> <M-b> :call ToggleExplorer()<CR>

" }}}

" }}}

" fuzzy finders {{{

let g:fzf_layout = {
  \'window': {
    \'width': 1,
    \'height': 1,
    \'border': 'sharp',
  \}
\}

nnoremap <silent> <M-p> :Files<CR>
nnoremap <silent> <M-F> :Rg<CR>

" }}}
