-- Automatic session management. No configuration needed!
-- vim:fdm=marker

vim.cmd([[

" directory setup {{{

let s:sessionDir = stdpath("data") . '/sessions' . g:projectDir
let s:sessionFile = s:sessionDir . '/se'

call mkdir(s:sessionDir, 'p')

" }}}

" deleteHiddenBuffers {{{

fu! s:deleteHiddenBuffers()
  let l:allBufs = nvim_list_bufs()
  let l:opts = { 'force': 1 }

  " Removal of the current element from a list does not affect
  " list iteration. See ':h for' for more details.
  for l:buf in l:allBufs

    " invalid buffers
    if !nvim_buf_is_valid(l:buf)
      call nvim_buf_delete(l:buf, l:opts)
      continue
    en

    " unloaded or hidden buffers
    if !nvim_buf_is_loaded(l:buf)
      call nvim_buf_delete(l:buf, l:opts)
      continue
    en

    let l:type = nvim_buf_get_option(l:buf, "buftype")
    let l:name = bufname(l:buf)

    " informational buffers
    if l:type == 'help' || l:type == 'quickfix' || l:name =~ "^man://"
      call nvim_buf_delete(l:buf, l:opts)
      continue
    en

    " terminal windows
    if l:type == 'terminal'
      call nvim_buf_delete(l:buf, l:opts)
      continue
    en

    " file explorers
    if l:type == 'directory' || l:name == 'NetrwTreeListing' || l:name =~ "^fern://"
      call nvim_buf_delete(l:buf, l:opts)
      continue
    en

  endfor
endfunction

" }}}

" session listeners {{{

fu! s:saveSession()
  call s:deleteHiddenBuffers()
  exe 'mksession! '.s:sessionFile
endfunction

fu! s:restoreSession()
  if filereadable(s:sessionFile)
    exe 'so '.s:sessionFile
  else
    " Folder is opened for the first time.
    " Delete the netrw buffer!
    bw!
  en
endfunction

augroup sessions
  au!
  au VimEnter * nested if g:openedWithDir | call s:restoreSession() | en
  au VimLeave * if g:openedWithDir | call s:saveSession() | en
augroup end

" }}}

]])
