" Simple file explorer using netrw. Made to be vifm-like.
" vim:fdm=marker

" file explorer {{{

" netrw
let g:netrw_banner=0 " hide banner
let g:netrw_use_errorwindow = 0 " hide error window
let g:netrw_list_hide = netrw_gitignore#Hide() . ',.git'

let s:hide_dirs = '^\%(\.git\|node_modules\|result\)$'
let s:hide_files = '\%(result\)\+'
let g:fern#default_exclude = s:hide_dirs.'\|'.s:hide_files

let g:fern#hide_cursor = 1
let g:fern#drawer_width = 40

exe 'nnoremap <silent> <M-b> :Fern '.g:projectDir.' -drawer -reveal=% -toggle<CR><C-w>='

let g:fern#disable_default_mappings = 1
function! s:init_fern() abort
  nmap <buffer> a <Plug>(fern-action-new-path)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> M <Plug>(fern-action-rename)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> v <Plug>(fern-action-mark:toggle)
  nmap <buffer> r <Plug>(fern-action-reload)

  nmap <buffer><nowait> h <Plug>(fern-action-collapse)
  nmap <buffer><nowait> h <Plug>(fern-action-collapse)
  nmap <buffer><nowait> l <Plug>(fern-action-open-or-expand)

  nmap <buffer> <M-h> <Plug>(fern-action-hidden:toggle)

  " mouse support
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <RightMouse> <Plug>(fern-action-mark:toggle)
endfunction

augroup fern
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup end

" cosmetics
let g:fern#renderer#default#leading = "  "
let g:fern#renderer#default#leaf_symbol = ""
let g:fern#renderer#default#collapsed_symbol = ""
let g:fern#renderer#default#expanded_symbol = ""

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
