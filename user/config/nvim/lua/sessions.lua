-- Automatic session management. No configuration needed!
-- vim:fdm=marker

-- directory setup {{{

local sessionDir = vim.fn.stdpath('data') .. '/sessions' .. vim.g.projectDir
-- TODO hide sessionFile from global scope once all session utils have been ported to lua
vim.g.sessionFile = sessionDir .. '/se'

os.execute('mkdir -p ' .. sessionDir)

-- }}}

vim.cmd([[

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
  exe 'mksession! '.g:sessionFile
endfunction

fu! s:restoreSession()
  if filereadable(g:sessionFile)
    exe 'so '.g:sessionFile
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
