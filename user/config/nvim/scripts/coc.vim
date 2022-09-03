" don't display warnings about old vim/node versions
let g:coc_disable_startup_warning = 1

" M-j and M-k navigates completion
fu! s:checkBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <M-j>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ <SID>checkBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><M-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" M-l confirms completion
inoremap <silent><expr> <M-l> coc#pum#visible() ? coc#pum#confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" M-g triggers (opens) completion
inoremap <silent><expr> <M-g> coc#refresh()

" [g and ]g navigate diagnostics (or use :CocDiagnostics)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" code navigation (via tag stack)
nmap <silent> <M-]> <Plug>(coc-definition)
nnoremap <M-o> <C-o>

" show docs for item
nnoremap <silent> gk :call <SID>showDocumentation()<cr>
nnoremap <silent> gh :call <SID>showDocumentation()<cr>
fu! s:showDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" M-f and M-b for scrolling in popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <M-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<M-f>"
  nnoremap <silent><nowait><expr> <M-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<M-b>"
  inoremap <silent><nowait><expr> <M-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <M-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <M-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<M-f>"
  vnoremap <silent><nowait><expr> <M-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<M-b>"
endif

" default extensions to install
let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-go',
  \ 'coc-json',
  \ ]
