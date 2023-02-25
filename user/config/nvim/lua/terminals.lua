-- Easier terminal buffers, similar to VSCode's terminal popup window.
-- vim:fdm=marker
local map = require('utils').map

vim.cmd([[

" setup and variables {{{

let s:numTerminals = 4

let s:shellName = expand('$SHELL')
if len(s:shellName) == 0
  let s:shellName = 'sh'
endif

let s:termList = map(range(s:numTerminals), -1)

let s:window = {
  \ 'isOpen': 0,
  \ 'win': -1,
  \ 'index': 0,
  \ 'bgwin': -1,
  \ }

" }}}

" create and exit terminal buffers {{{

fu! s:createTerminal()
  call termopen(s:shellName, { 'on_exit': 'ExitTerminal', 'cwd': g:projectDir })
endfunction

fu! g:ExitTerminal(job_id, code, event) dict
  bw! " kill terminal window
  bw! " kill bg window
  let s:termList[s:window.index] = -1
  let s:window.isOpen = 0
  let s:window.win = -1
  let s:window.index = 0
  let s:window.bgwin = -1
endfunction

" }}}

" open window {{{

fu! s:openWindow()
  let l:opts = { 'x': 0, 'y': 0, 'w': 1, 'h': 1 }

  let l:col = float2nr(&columns * l:opts.x)
  let l:row = float2nr(&lines * l:opts.y)
  let l:width = float2nr(&columns * l:opts.w)
  let l:height = float2nr(&lines * l:opts.h)

  " background
  let l:bgb = nvim_create_buf(v:false, v:true)
  let l:top = "┌" . repeat("─", l:width - 2) . "┐"
  let l:mid = "│" . repeat(" ", l:width - 2) . "│"
  let l:bot = "└" . repeat("─", l:width - 2) . "┘"
  let l:lines = [l:top] + repeat([l:mid], l:height - 3) + [l:bot]
  call nvim_buf_set_lines(l:bgb, 0, -1, v:true, l:lines)
  let l:bgOpts = {
    \ 'relative': 'editor',
    \ 'style': 'minimal',
    \ 'col': l:col,
    \ 'row': l:row,
    \ 'width': l:width,
    \ 'height': l:height - 1
    \ }
  let l:bgwin = nvim_open_win(l:bgb, v:true, l:bgOpts)
  call setwinvar(l:bgwin, '&winhl', 'Normal:WindowBorder')

  let l:fgOpts = {
    \ 'relative': 'editor',
    \ 'style': 'minimal',
    \ 'col': l:col + 2,
    \ 'row': l:row + 1,
    \ 'width': l:width - 4,
    \ 'height': l:height - 3
    \ }

  " open with current buffer for now - we'll replace it with a terminal later
  let l:win = nvim_open_win(0, v:true, l:fgOpts)

  let s:window.win = l:win
  let s:window.bgwin = l:bgwin
  let s:window.isOpen = 1
endfunction

" }}}

" toggle terminal window {{{

fu! g:ToggleTermWindow()
  if s:window.isOpen " if terminal window exists and is open
    let s:window.isOpen = 0
    call nvim_set_current_win(s:window.win) | hide
    " border buffer is deleted by default since it is unmodifiable
    call nvim_set_current_win(s:window.bgwin) | hide

  else " if terminal window is closed or does not exist yet
    let s:window.isOpen = 1
    call s:openWindow()
    call FocusTerminal(s:window.index)

  endif
endfunction

" }}}

" focus terminal {{{

fu! g:FocusTerminal(i)
  let s:window.index = a:i
  let l:hasNoTermBuf = s:termList[s:window.index] < 0

  if l:hasNoTermBuf
    let s:termList[s:window.index] = nvim_create_buf(v:false, v:true)
  endif

  call nvim_set_current_buf(s:termList[s:window.index])

  if l:hasNoTermBuf
    call s:createTerminal()
  endif

  startinsert
endfunction

" }}}

" keymaps {{{

for i in range(s:numTerminals)
  let s:n = i + 1
  exe 'tnoremap <silent> <M-'.s:n.'> <C-\><C-n>:call g:FocusTerminal('.i.')<CR>' 
endfor

]])

map('n', '<M-`>', ':call g:ToggleTermWindow()<CR>', {silent = true})
map('t', '<M-`>', '<C-\\><C-n>:call g:ToggleTermWindow()<CR>', {silent = true})

-- }}}
